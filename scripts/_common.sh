#=================================================
# COMMON VARIABLES
#=================================================

swap_needed=1024

# PHP
composer_version="2.0.13"

# Version numbers
project_version="1.8.0"
#core_version is now retrieved from the manifest
ldap_version="*"

#=================================================
# PERSONAL HELPERS
#=================================================

# Activate extension in Flarum's database
# usage: activate_flarum_extension $db_name $extension $short_extension
# $short_extension is the extension name written in database, how it is shortened is still a mystery
activate_flarum_extension() {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [d]=database= [s]=short_extension= )
	local database
	local short_extension
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	database="${database:-$db_name}"

	local sql_command
	local old_extensions_enabled
	local addition
	local new_extensions_enabled

	# Retrieve current extensions
	sql_command="SELECT \`value\` FROM settings WHERE \`key\` = 'extensions_enabled'"
	old_extensions_enabled=$(ynh_mysql_db_shell $database <<< "$sql_command" | tail -1)

	# Use jq to test presence of the extension in the list of enabled extensions
	# if not, then add it.
	new_extensions_enabled=$(jq -jrc --arg short_extension $short_extension '. + [ $short_extension ] | unique' <<< $old_extensions_enabled)

	# Update activated extensions list
	sql_command="UPDATE \`settings\` SET \`value\`='$new_extensions_enabled' WHERE \`key\`='extensions_enabled';"
	ynh_mysql_db_shell $database <<< "$sql_command"
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================
ynh_add_swap_btrfs() {
    if systemd-detect-virt --container --quiet; then
        ynh_print_warn --message="You are inside a container/VM. swap will not be added, but that can cause troubles for the app $app. Please make sure you have enough RAM available."
        return
    fi

    # Declare an array to define the options of this helper.
    declare -Ar args_array=([s]=size=)
    local size
    # Manage arguments with getopts
    ynh_handle_getopts_args "$@"

    local swap_max_size=$(($size * 1024))

    local free_space=$(df --output=avail / | sed 1d)
    # Because we don't want to fill the disk with a swap file, divide by 2 the available space.
    local usable_space=$(($free_space / 2))

    SD_CARD_CAN_SWAP=${SD_CARD_CAN_SWAP:-0}

    # Swap on SD card only if it's is specified
    if ynh_is_main_device_a_sd_card && [ "$SD_CARD_CAN_SWAP" == "0" ]; then
        ynh_print_warn --message="The main mountpoint of your system '/' is on an SD card, swap will not be added to prevent some damage of this one, but that can cause troubles for the app $app. If you still want activate the swap, you can relaunch the command preceded by 'SD_CARD_CAN_SWAP=1'"
        return
    fi

    # Compare the available space with the size of the swap.
    # And set a acceptable size from the request
    if [ $usable_space -ge $swap_max_size ]; then
        local swap_size=$swap_max_size
    elif [ $usable_space -ge $(($swap_max_size / 2)) ]; then
        local swap_size=$(($swap_max_size / 2))
    elif [ $usable_space -ge $(($swap_max_size / 3)) ]; then
        local swap_size=$(($swap_max_size / 3))
    elif [ $usable_space -ge $(($swap_max_size / 4)) ]; then
        local swap_size=$(($swap_max_size / 4))
    else
        echo "Not enough space left for a swap file" >&2
        local swap_size=0
    fi

    # If there's enough space for a swap, and no existing swap here
    if [ $swap_size -ne 0 ] && [ ! -e /swap_$app ]; then
        # Create file
        truncate -s 0 /swap_$app

        # set the No_COW attribute on the swapfile with chattr
        if findmnt -n -o FSTYPE / | grep -q btrfs; then
  		chattr +C /swap_flarum || true
	fi

        # Preallocate space for the swap file, fallocate may sometime not be used, use dd instead in this case
        if ! fallocate -l ${swap_size}K /swap_$app; then
            dd if=/dev/zero of=/swap_$app bs=1024 count=${swap_size}
        fi
        chmod 0600 /swap_$app
        # Create the swap
        mkswap /swap_$app
        # And activate it
        swapon /swap_$app
        # Then add an entry in fstab to load this swap at each boot.
        echo -e "/swap_$app swap swap defaults 0 0 #Swap added by $app" >> /etc/fstab
    fi
}

# See ynh_* scripts

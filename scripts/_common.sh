#=================================================
# COMMON VARIABLES
#=================================================

#swap_needed=1024

MEMORY_NEEDED="2560"

YNH_PHP_VERSION="7.3"
YNH_COMPOSER_VERSION="2.0.13"

extra_php_dependencies="php${YNH_PHP_VERSION}-curl php${YNH_PHP_VERSION}-dom php${YNH_PHP_VERSION}-gd php${YNH_PHP_VERSION}-json php${YNH_PHP_VERSION}-mbstring php${YNH_PHP_VERSION}-pdo-mysql php${YNH_PHP_VERSION}-tokenizer php${YNH_PHP_VERSION}-zip"

# Version numbers
project_version="~0.1.0-beta.16"
core_version="~0.1.0-beta.16"
ldap_version="~0.1.0-beta.16-1"

#=================================================
# PERSONAL HELPERS
#=================================================

# Activate extension in Flarum's database
# usage: activate_flarum_extension $db_name $extension $short_extension
# $short_extension is the extension name written in database, how it is shortened is still a mystery
activate_flarum_extension() {
	# Declare an array to define the options of this helper.
	local legacy_args=ds
	declare -Ar args_array=( [d]=database= [s]=short_extension )
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
	old_extensions_enabled=$(ynh_mysql_execute_as_root "$sql_command" $database | tail -1)

	# Append the extension name at the end of the list
	addition=",\"${short_extension}\"]"
	new_extensions_enabled=${old_extensions_enabled::-1}$addition
	# Update activated extensions list
	sql_command="UPDATE \`settings\` SET \`value\`='$new_extensions_enabled' WHERE \`key\`='extensions_enabled';"
	ynh_mysql_execute_as_root "$sql_command" $database
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# Add swap
#
# usage: ynh_add_swap --size=SWAP in Mb
# | arg: -s, --size= - Amount of SWAP to add in Mb.
ynh_add_swap () {
	# Declare an array to define the options of this helper.
	declare -Ar args_array=( [s]=size= )
	local size
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"

	local swap_max_size=$(( $size * 1024 ))

	local free_space=$(df --output=avail / | sed 1d)
	# Because we don't want to fill the disk with a swap file, divide by 2 the available space.
	local usable_space=$(( $free_space / 2 ))

 	SD_CARD_CAN_SWAP=${SD_CARD_CAN_SWAP:-0}

	# Swap on SD card only if it's is specified
	if ynh_is_main_device_a_sd_card && [ "$SD_CARD_CAN_SWAP" == "0" ]
	then
		ynh_print_warn --message="The main mountpoint of your system '/' is on an SD card, swap will not be added to prevent some damage of this one, but that can cause troubles for the app $app. If you still want activate the swap, you can relaunch the command preceded by 'SD_CARD_CAN_SWAP=1'"
		return
	fi

	# Compare the available space with the size of the swap.
	# And set a acceptable size from the request
	if [ $usable_space -ge $swap_max_size ]
	then
		local swap_size=$swap_max_size
	elif [ $usable_space -ge $(( $swap_max_size / 2 )) ]
	then
		local swap_size=$(( $swap_max_size / 2 ))
	elif [ $usable_space -ge $(( $swap_max_size / 3 )) ]
	then
		local swap_size=$(( $swap_max_size / 3 ))
	elif [ $usable_space -ge $(( $swap_max_size / 4 )) ]
	then
		local swap_size=$(( $swap_max_size / 4 ))
	else
		echo "Not enough space left for a swap file" >&2
		local swap_size=0
	fi

	# If there's enough space for a swap, and no existing swap here
	if [ $swap_size -ne 0 ] && [ ! -e /swap_$app ]
	then
		# Preallocate space for the swap file, fallocate may sometime not be used, use dd instead in this case
		if ! fallocate -l ${swap_size}K /swap_$app
		then
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

ynh_del_swap () {
	# If there a swap at this place
	if [ -e /swap_$app ]
	then
		# Clean the fstab
		sed -i "/#Swap added by $app/d" /etc/fstab
		# Desactive the swap file
		swapoff /swap_$app
		# And remove it
		rm /swap_$app
	fi
}

# Check if the device of the main mountpoint "/" is an SD card
#
# [internal]
#
# return 0 if it's an SD card, else 1
ynh_is_main_device_a_sd_card () {
	local main_device=$(lsblk --output PKNAME --noheadings $(findmnt / --nofsroot --uniq --output source --noheadings --first-only))

	if echo $main_device | grep --quiet "mmc" && [ $(tail -n1 /sys/block/$main_device/queue/rotational) == "0" ]
	then
		return 0
	else
		return 1
	fi
}

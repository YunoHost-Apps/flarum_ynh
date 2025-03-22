#=================================================
# COMMON VARIABLES
#=================================================

swap_needed=1024

# PHP
composer_version="2.8.6"

# Version numbers
project_version="1.8.0"
ldap_version="*"

#=================================================
# PERSONAL HELPERS
#=================================================

# Activate extension in Flarum's database
# usage: activate_flarum_extension -d $db_name -s $extension
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
chattr() {
  if findmnt -n -o FSTYPE / | grep -q btrfs; then
    echo "Running chattr $* (Btrfs detected)"
    command chattr "$@"
  else
    echo "Skipping chattr $* (not Btrfs)"
  fi
}

# See ynh_* scripts

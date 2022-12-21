#=================================================
# COMMON VARIABLES
#=================================================

swap_needed=1024

# PHP
YNH_PHP_VERSION="7.4"
YNH_COMPOSER_VERSION="2.0.13"
extra_php_dependencies="php${YNH_PHP_VERSION}-curl php${YNH_PHP_VERSION}-dom php${YNH_PHP_VERSION}-gd php${YNH_PHP_VERSION}-json php${YNH_PHP_VERSION}-mbstring php${YNH_PHP_VERSION}-pdo-mysql php${YNH_PHP_VERSION}-tokenizer php${YNH_PHP_VERSION}-zip php${YNH_PHP_VERSION}-ldap"

# dependencies used by the app
pkg_dependencies="$extra_php_dependencies"

# Version numbers
project_version="1.6.0"
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

	# Use jq to test presence of the extension in the list of enabled extensions
	# if not, then add it.
	new_extensions_enabled=$(jq -jrc --arg short_extension 'if (any(index("$short_extension")) | not) then . |= + $short_extension else . end' <<< $old_extensions_enabled)

	# Update activated extensions list
	sql_command="UPDATE \`settings\` SET \`value\`='$new_extensions_enabled' WHERE \`key\`='extensions_enabled';"
	ynh_mysql_execute_as_root "$sql_command" $database
}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# See ynh_* scripts

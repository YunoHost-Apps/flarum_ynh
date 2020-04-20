#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies=""
extra_pkg_dependencies="php7.3-curl php7.3-dom php7.3-gd php7.3-json php7.3-mbstring php7.3-pdo-mysql php7.3-tokenizer php7.3-zip"

# Version numbers
php_version="7.3"
project_version="0.1.0-beta.12"
core_version="0.1.0-beta.12"
ssowat_version="0.1.0-beta.12"

#=================================================
# PERSONAL HELPERS
#=================================================

# Install extension, and activate it in database
# usage: install_and_activate_extension $user $php_version $final_path $db_name $extension $short_extension
# $extension is the "vendor/extension-name" string from packagist
# $short_extension is the extension name written in database, how it is shortened is still a mystery
install_and_activate_extension() {
	# Declare an array to define the options of this helper.
	local legacy_args=uvwdes
	declare -Ar args_array=( [u]=user= [v]=phpversion= [w]=workdir= [d]=database= [e]=extension= [s]=short_extension )
	local user
	local phpversion
	local workdir
	local database
	local extension
	local short_extension
	# Manage arguments with getopts
	ynh_handle_getopts_args "$@"
	user="${user:-$app}"
	phpversion="${phpversion:-$php_version}"
	workdir="${workdir:-$final_path}"
	database="${database:-$db_name}"

	local sql_command
	local old_extensions_enabled
	local addition
	local new_extensions_enabled

	# Install extension
	ynh_composer_exec --user=$user --phpversion="${phpversion}" --workdir="$workdir" --commands="require $extension"

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

# See ynh_* scripts

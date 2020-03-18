#=================================================
# COMMON VARIABLES
#=================================================

# dependencies used by the app
pkg_dependencies="php7.3-curl php7.3-dom php7.3-gd php7.3-json php7.3-mbstring php7.3-pdo-mysql php7.3-tokenizer php7.3-zip"

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
	local AS_USER=$1
	local PHP_VERSION=$2
	local WORKDIR=$3
	local DB_NAME=$4
	local EXTENSION=$5
	local SHORT_EXTENSION=$6
	local sql_command
	local old_extensions_enabled
	local addition
	local new_extensions_enabled

	# Install extension
	ynh_composer_exec $AS_USER $PHP_VERSION $WORKDIR "require $EXTENSION -n --ansi -d $WORKDIR"

	# Retrieve current extensions
	sql_command="SELECT \`value\` FROM settings WHERE \`key\` = 'extensions_enabled'"
	old_extensions_enabled=$(ynh_mysql_execute_as_root "$sql_command" $db_name | tail -1)

	# Append the extension name at the end of the list
	addition=",\"${SHORT_EXTENSION}\"]"
	new_extensions_enabled=${old_extensions_enabled::-1}$addition
	# Update activated extensions list
	sql_command="UPDATE \`settings\` SET \`value\`='$new_extensions_enabled' WHERE \`key\`='extensions_enabled';"
	ynh_mysql_execute_as_root "$sql_command" $DB_NAME

}

#=================================================
# EXPERIMENTAL HELPERS
#=================================================

# See ynh_* scripts

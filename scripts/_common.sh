# Execute a command as another user
# usage: exec_as USER COMMAND [ARG ...]
exec_as() {
	local USER=$1
	shift 1

	if [[ $USER = $(whoami) ]]
	then
		eval $@
	else
		sudo -u "$USER" $@
	fi
}

# Execute a composer command from a given directory
# usage: composer_exec AS_USER WORKDIR COMMAND [ARG ...]
exec_composer() {
	local AS_USER=$1
	local WORKDIR=$2
	shift 2

  # Do not run composer as root
  if [ $AS_USER = "root" ] ; then ynh_die "Do not run composer as root" ; fi

	exec_as "$AS_USER" COMPOSER_HOME="${WORKDIR}/.composer" \
		php "${WORKDIR}/composer.phar" $@ \
		-d "${WORKDIR}" -d memory_limit=-1 --quiet --no-interaction
}

# Install and initialize Composer in the given directory
# usage: init_composer destdir
init_composer() {
	local AS_USER=$1
	local WORKDIR=$2

  # Do not install composer as root
  if [ $AS_USER = "root" ] ; then ynh_die "Do not install composer as root" ; fi

	# install composer
	curl -sS https://getcomposer.org/installer \
		| COMPOSER_HOME="${WORKDIR}/.composer" \
		php -- --quiet --install-dir="$WORKDIR" \
		|| ynh_die "Unable to install Composer"

	# update dependencies to create composer.lock
	#exec_composer "$AS_USER" "$WORKDIR" install --no-dev \
	#	|| ynh_die "Unable to update core dependencies with Composer"
}

# Install extension, and activate it in database
# usage: install_and_activate_extension $user $final_path $db_name $extension $short_extension
# $extension is the "vendor/extension-name" string from packagist
# $short_extension is the extension name written in database, how it is shortened is still a mystery
install_and_activate_extension() {
	local AS_USER=$1
	local WORKDIR=$2
	local DB_NAME=$3
	local EXTENSION=$4
	local SHORT_EXTENSION=$5
	local sql_command
	local old_extensions_enabled
	local addition
	local new_extensions_enabled

	# Install extension
	exec_composer $AS_USER $WORKDIR "require $EXTENSION --ansi"

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

# Send an email to inform the administrator
#
# usage: ynh_send_readme_to_admin app_message [recipients]
# | arg: app_message - The message to send to the administrator.
# | arg: recipients - The recipients of this email. Use spaces to separate multiples recipients. - default: root
#	example: "root admin@domain"
#	If you give the name of a YunoHost user, ynh_send_readme_to_admin will find its email adress for you
#	example: "root admin@domain user1 user2"
ynh_send_readme_to_admin() {
	local app_message="${1:-...No specific information...}"
	local recipients="${2:-root}"

	# Retrieve the email of users
	find_mails () {
		local list_mails="$1"
		local mail
		local recipients=" "
		# Read each mail in argument
		for mail in $list_mails
		do
			# Keep root or a real email address as it is
			if [ "$mail" = "root" ] || echo "$mail" | grep --quiet "@"
			then
				recipients="$recipients $mail"
			else
				# But replace an user name without a domain after by its email
				if mail=$(ynh_user_get_info "$mail" "mail" 2> /dev/null)
				then
					recipients="$recipients $mail"
				fi
			fi
		done
		echo "$recipients"
	}
	recipients=$(find_mails "$recipients")

	local mail_subject="☁️🆈🅽🅷☁️: \`$app\` was just installed!"

	local mail_message="This is an automated message from your beloved YunoHost server.

Specific information for the application $app.

$app_message

---
Automatic diagnosis data from YunoHost

$(yunohost tools diagnosis | grep -B 100 "services:" | sed '/services:/d')"

	# Define binary to use for mail command
	if [ -e /usr/bin/bsd-mailx ]
	then
		local mail_bin=/usr/bin/bsd-mailx
	else
		local mail_bin=/usr/bin/mail.mailutils
	fi

	# Send the email to the recipients
	echo "$mail_message" | $mail_bin -a "Content-Type: text/plain; charset=UTF-8" -s "$mail_subject" "$recipients"
}


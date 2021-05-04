INSERT INTO `settings` (`key`, `value`) VALUES
('tituspijean-auth-ldap.admin_dn', ''),
('tituspijean-auth-ldap.admin_password', ''),
('tituspijean-auth-ldap.base_dn', 'ou=users,dc=yunohost,dc=org'),
('tituspijean-auth-ldap.filter', '(&(objectClass=posixAccount)(permission=cn=flarum.main,ou=permission,dc=yunohost,dc=org))'),
('tituspijean-auth-ldap.follow_referrals', '0'),
('tituspijean-auth-ldap.hosts', 'localhost'),
('tituspijean-auth-ldap.method_name', 'YunoHost'),
('tituspijean-auth-ldap.onlyUse', '1'),
('tituspijean-auth-ldap.port', '389'),
('tituspijean-auth-ldap.search_user_fields', 'uid,mail'),
('tituspijean-auth-ldap.use_ssl', ''),
('tituspijean-auth-ldap.use_tls', ''),
('tituspijean-auth-ldap.user_mail', 'mail'),
('tituspijean-auth-ldap.user_username', 'uid')
ON DUPLICATE KEY UPDATE value = VALUES(value);

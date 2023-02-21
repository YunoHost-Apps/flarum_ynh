## Login

This app allows your YunoHost users to log in with a [dedicated LDAP extension](https://github.com/tituspijean/flarum-ext-auth-ldap). By default, the standard logging method is hidden.
To allow non-YunoHost users to log in, tune the LDAP extension setting in Flarum's admin panel.

### Upgrading

Note that, for the moment, all third-party extensions are removed upon upgrading.
Their data and parameters remain in Flarum's database, they only require to be reinstalled.

### Adding extensions

Flarum does not offer to install extensions from its admin panel yet, so you need to use the command line.

Replace `vendor/extension` with the appropriate names. Read the extension documentation if it requires additional steps.

```bash
sudo su
app=__ID__
cd /var/www/$app
sudo -u $app php__PHPVERSION__ composer.phar require vendor/extension
```

#### Troubleshooting

##### `Timeout` errors
Some users have reported a successful installation, but get a blank page due to a `timeout` on a PHP script that prepares the forum assests (`Minify.php`, notably).

In `/etc/php/__PHPVERSION__/fpm/pool.d/__ID__.conf`, you can increase the `max_execution_time` and `max_input_time` limits (both values are in seconds if nothing is specified).

Reload PHP-FPM with `sudo service php__PHPVERSION__-fpm reload`.

##### Upload limit
If you are facing an error while uploading large files into the forum, PHP may be limiting file upload.

In `/etc/php/__PHPVERSION__/fpm/pool.d/__ID__.conf`, you can uncomment (remove `;` at the beginning of the line) and increase the values of `upload_max_filesize` and `post_max_size` (both values are in bytes).

Reload PHP-FPM with `sudo service php__PHP_VERSION__-fpm reload`.

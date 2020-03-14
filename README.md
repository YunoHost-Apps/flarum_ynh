# Flarum for YunoHost

[![Install Flarum with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=flarum)

[![Integration level](https://ci-apps.yunohost.org/ci/logs/flarum%20%28Apps%29.svg)](https://dash.yunohost.org/appci/app/flarum) [![Flarum version](https://img.shields.io/badge/flarum-0.1.0--beta.12-green.svg)](https://github.com/flarum/flarum/releases/tag/v0.1.0-beta.12) ![PHP version](https://img.shields.io/badge/php-7.3-green.svg)

[Flarum](http://flarum.org/), an open-source forum software, packaged for [YunoHost](https://yunohost.org/), a self-hosting server operating server.

![](http://flarum.org/img/screenshot_2x.png)

## Features

- All Flarum features, see its [documentation](http://flarum.org/docs/)
- SSOwat integration through a [dedicated extension](https://github.com/tituspijean/flarum-ext-auth-ssowat).

## Installation

This Flarum package can be installed through:
- YunoHost's webadmin, in the Community listing
- YunoHost's CLI: `yunohost app install https://github.com/YunoHost-Apps/flarum_ynh`.

Required parameters are:
- `domain`
- `path`
- `admin`, among the YunoHosts users
- `public`, *true* by default, for guests to read the forum
- `title` of the forum
- `language` can be English `en` (by default), French `fr`, and German `de`. Other languages are installable after installation like any other extensions
- `bazaar_extension` to install the extension marketplace (*false* by default), to avoid using the command line to add new extensions.

After installation, simply open your browser to Flarum's page. First loading may be a bit longer as assets are generated.

## Upgrading

Note that all third-party extensions are removed upon upgrading.

## Adding extensions after installation

Replace `flarum` with your app ID in case of multiple installation.
Replace `vendor/extension` with the appropriate names. Read the extension documentation if it requires additional steps.

```bash
app=flarum
cd /var/www/$app
sudo -u $app php7.3 composer.phar require vendor/extension
```

## Troubleshooting

### `Low memory` errors
A swapfile will enable your system to extend its limited memory through its disk capacity. The following commands will create a 1 GB swapfile.
```
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1024000
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```

Then add this line in `/etc/fstab`:
```
/swapfile none swap sw 0 0
```

Reboot the system and try the installation again.

### `Timeout` errors
Some users have reported a successful installation, but get a blank page due to a `timeout` on a PHP script that prepares the forum assests (`Minify.php`, notably).

In `/etc/php/*php_version*/fpm/pool.d/*app_id*.conf`, you can increase the `max_execution_time` and `max_input_time` limits (both values are in seconds if nothing is specified).

Reload PHP-FPM with `sudo service php*php_version*-fpm reload`.

### Upload limit
If you are facing an error while uploading large files into the forum, PHP may be limiting file upload.

In `/etc/php/*php_version*/fpm/pool.d/*app_id*.conf`, you can uncomment (remove `;` at the beginning of the line) and increase the values of `upload_max_filesize` and `post_max_size` (both values are in bytes).

Reload PHP-FPM with `sudo service php*php_version*-fpm reload`.

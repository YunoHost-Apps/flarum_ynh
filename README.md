# Flarum package for YunoHost
[Flarum](http://flarum.org/), an open-source forum software, packaged for [YunoHost](https://yunohost.org/), a self-hosting server operating server.

## Development status
Package is **in progress** : installation works, removal partially works. Upgrading, backing up and restoring don't.

[SSOwat integration](https://github.com/tituspijean/flarum-ext-auth-ssowat) is **non functional** and removed.

## Install
Flarum requires `composer`, which should be automatically retrieved and installed.

## Post-installation
Post-installation is **automated**.

However, if you leave the forum title field empty in YunoHost's form, automatic post-installation will not be launched.

1. Retrieve database password:
  * It should be displayed in the log messages on top of installation page.
  * Otherwise, display in command prompt with `sudo cat /etc/yunohost/apps/flarum/settings.yml | grep mysql` (Replace `flarum` by its actual app id if you are using multiple flarum instances in YunoHost)
  
2. Go to your Flarum homepage to initiate manual post-installation.

3. Fill in the blanks about `MySQL` as follow, put the retrieved database password. The remaining blanks are up to you.

<p align="center"><img src="http://i.imgur.com/p7XmTDw.png" width="300" ></p>

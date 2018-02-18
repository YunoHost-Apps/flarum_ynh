Flarum for YunoHost
-------------------
[Flarum](http://flarum.org/), an open-source forum software, packaged for [YunoHost](https://yunohost.org/), a self-hosting server operating server.

**Shipped version:**  0.1.0-beta.7

![](http://flarum.org/img/screenshot_2x.png)

## Features

- All Flarum features, see its [documentation](http://flarum.org/docs/)
- SSOwat integration through a [dedicated extension](https://github.com/tituspijean/flarum-ext-auth-ssowat)

## Installation
Flarum is available in the Community listing.

You can also install it with `yunohost app install https://github.com/YunoHost-Apps/flarum_ynh`.

- Required parameters are :
  - `domain`
  - `path`
  - `admin`, among the YunoHosts users
  - `public`, *true* by default, for guests to read the forum
- Optional parameters are :
  - `title` :warning: if you leave it empty, you will have to perform manual post-installation.
  - `language` can be English (by default), French, and German. Other languages installable after installation as any other extensions

### Manual post-installation

1. Retrieve database password:
  * It should be displayed in the log messages, on top of installation page, for web installations.
  * For command line installations, `sudo cat /etc/yunohost/apps/flarum/settings.yml | grep mysql` (Replace `flarum` by its actual app id if you are using multiple Flarum instances in YunoHost)
  
2. Go to your Flarum homepage to initiate manual post-installation.

3. Fill in the blanks about `MySQL` as follow, put the retrieved database password. The remaining blanks are up to you.

<p align="center"><img src="http://i.imgur.com/p7XmTDw.png" width="300" ></p>


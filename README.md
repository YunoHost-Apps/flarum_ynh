Flarum for YunoHost
-------------------

[![Integration level](https://dash.yunohost.org/integration/flarum.svg)](https://dash.yunohost.org/appci/app/flarum)

[![Install Hubzilla with YunoHost](https://install-app.yunohost.org/install-with-yunohost.png)](https://install-app.yunohost.org/?app=flarum)

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
  - `title` of the forum
  - `language` can be English (by default), French, and German. Other languages installable after installation as any other extensions
  - `bazaar_extension` to install the extension marketplace (*false* by default), to avoid using the command line to add new extensions.

<!--
Ohart ongi: README hau automatikoki sortu da <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>ri esker
EZ editatu eskuz.
-->

# Flarum YunoHost-erako

[![Integrazio maila](https://dash.yunohost.org/integration/flarum.svg)](https://ci-apps.yunohost.org/ci/apps/flarum/) ![Funtzionamendu egoera](https://ci-apps.yunohost.org/ci/badges/flarum.status.svg) ![Mantentze egoera](https://ci-apps.yunohost.org/ci/badges/flarum.maintain.svg)

[![Instalatu Flarum YunoHost-ekin](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=flarum)

*[Irakurri README hau beste hizkuntzatan.](./ALL_README.md)*

> *Pakete honek Flarum YunoHost zerbitzari batean azkar eta zailtasunik gabe instalatzea ahalbidetzen dizu.*  
> *YunoHost ez baduzu, kontsultatu [gida](https://yunohost.org/install) nola instalatu ikasteko.*

## Aurreikuspena

Flarum is a simple discussion platform for your website. It's fast and easy to use, with all the features you need to run a successful community.

**Paketatutako bertsioa:** 1.8.7~ynh1

**Demoa:** <https://discuss.flarum.org/d/21101-demos-come-to-flarum>

## Pantaila-argazkiak

![Flarum(r)en pantaila-argazkia](./doc/screenshots/beta16.jpg)

## Dokumentazioa eta baliabideak

- Aplikazioaren webgune ofiziala: <https://flarum.org>
- Administratzaileen dokumentazio ofiziala: <https://docs.flarum.org>
- Jatorrizko aplikazioaren kode-gordailua: <https://github.com/flarum/framework>
- YunoHost Denda: <https://apps.yunohost.org/app/flarum>
- Eman errore baten berri: <https://github.com/YunoHost-Apps/flarum_ynh/issues>

## Garatzaileentzako informazioa

Bidali `pull request`a [`testing` abarrera](https://github.com/YunoHost-Apps/flarum_ynh/tree/testing).

`testing` abarra probatzeko, ondorengoa egin:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
edo
sudo yunohost app upgrade flarum -u https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
```

**Informazio gehiago aplikazioaren paketatzeari buruz:** <https://yunohost.org/packaging_apps>

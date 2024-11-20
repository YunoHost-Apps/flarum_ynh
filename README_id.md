<!--
N.B.: README ini dibuat secara otomatis oleh <https://github.com/YunoHost/apps/tree/master/tools/readme_generator>
Ini TIDAK boleh diedit dengan tangan.
-->

# Flarum untuk YunoHost

[![Tingkat integrasi](https://dash.yunohost.org/integration/flarum.svg)](https://ci-apps.yunohost.org/ci/apps/flarum/) ![Status kerja](https://ci-apps.yunohost.org/ci/badges/flarum.status.svg) ![Status pemeliharaan](https://ci-apps.yunohost.org/ci/badges/flarum.maintain.svg)

[![Pasang Flarum dengan YunoHost](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=flarum)

*[Baca README ini dengan bahasa yang lain.](./ALL_README.md)*

> *Paket ini memperbolehkan Anda untuk memasang Flarum secara cepat dan mudah pada server YunoHost.*  
> *Bila Anda tidak mempunyai YunoHost, silakan berkonsultasi dengan [panduan](https://yunohost.org/install) untuk mempelajari bagaimana untuk memasangnya.*

## Ringkasan

Flarum is a simple discussion platform for your website. It's fast and easy to use, with all the features you need to run a successful community.

**Versi terkirim:** 1.8.9~ynh1

**Demo:** <https://discuss.flarum.org/d/21101-demos-come-to-flarum>

## Tangkapan Layar

![Tangkapan Layar pada Flarum](./doc/screenshots/beta16.jpg)

## Dokumentasi dan sumber daya

- Website aplikasi resmi: <https://flarum.org>
- Dokumentasi admin resmi: <https://docs.flarum.org>
- Depot kode aplikasi hulu: <https://github.com/flarum/framework>
- Gudang YunoHost: <https://apps.yunohost.org/app/flarum>
- Laporkan bug: <https://github.com/YunoHost-Apps/flarum_ynh/issues>

## Info developer

Silakan kirim pull request ke [`testing` branch](https://github.com/YunoHost-Apps/flarum_ynh/tree/testing).

Untuk mencoba branch `testing`, silakan dilanjutkan seperti:

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
atau
sudo yunohost app upgrade flarum -u https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
```

**Info lebih lanjut mengenai pemaketan aplikasi:** <https://yunohost.org/packaging_apps>

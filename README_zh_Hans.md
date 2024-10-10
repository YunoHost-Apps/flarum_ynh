<!--
注意：此 README 由 <https://github.com/YunoHost/apps/tree/master/tools/readme_generator> 自动生成
请勿手动编辑。
-->

# YunoHost 上的 Flarum

[![集成程度](https://dash.yunohost.org/integration/flarum.svg)](https://ci-apps.yunohost.org/ci/apps/flarum/) ![工作状态](https://ci-apps.yunohost.org/ci/badges/flarum.status.svg) ![维护状态](https://ci-apps.yunohost.org/ci/badges/flarum.maintain.svg)

[![使用 YunoHost 安装 Flarum](https://install-app.yunohost.org/install-with-yunohost.svg)](https://install-app.yunohost.org/?app=flarum)

*[阅读此 README 的其它语言版本。](./ALL_README.md)*

> *通过此软件包，您可以在 YunoHost 服务器上快速、简单地安装 Flarum。*  
> *如果您还没有 YunoHost，请参阅[指南](https://yunohost.org/install)了解如何安装它。*

## 概况

Flarum is a simple discussion platform for your website. It's fast and easy to use, with all the features you need to run a successful community.

**分发版本：** 1.8.7~ynh1

**演示：** <https://discuss.flarum.org/d/21101-demos-come-to-flarum>

## 截图

![Flarum 的截图](./doc/screenshots/beta16.jpg)

## 文档与资源

- 官方应用网站： <https://flarum.org>
- 官方管理文档： <https://docs.flarum.org>
- 上游应用代码库： <https://github.com/flarum/framework>
- YunoHost 商店： <https://apps.yunohost.org/app/flarum>
- 报告 bug： <https://github.com/YunoHost-Apps/flarum_ynh/issues>

## 开发者信息

请向 [`testing` 分支](https://github.com/YunoHost-Apps/flarum_ynh/tree/testing) 发送拉取请求。

如要尝试 `testing` 分支，请这样操作：

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
或
sudo yunohost app upgrade flarum -u https://github.com/YunoHost-Apps/flarum_ynh/tree/testing --debug
```

**有关应用打包的更多信息：** <https://yunohost.org/packaging_apps>

### Installation

- L'installation nécessite au moins 1 Go de mémoire vive libre. Un fichier *swap* de cette taille sera créé si nécessaire.
- Vous pouvez sélectionner la langue par défaut dans les paramètres d'installation (parmi l'anglais `en`, le français `fr` et l'allemand `de`). Les autres langues sont installables comme n'importe quelle autre extension.

### Utilisation

Après l'installation, ouvrez simplement votre navigateur à la page de Flarum. Le premier chargement peut être un peu retardé par la génération du cache.

Cette app permet à vos utilisateurs enregistrés dans YunoHost de se connecter avec une [extension LDAP dédiée](https://github.com/tituspijean/flarum-ext-auth-ldap). Par défaut, la méthode de connexion standard est cachée.
Pour permettre à des utilisateurs non-YunoHost de se connecter, référez-vous au menu de configuration de l'extension LDAP dans le panneau d'administration de Flarum.

### Mise à jour

Notez que, pour le moment, toute extension tierce est désinstallée lors d'une mise à jour.
Leurs données et paramètres restent dans la base de donnée de Flarum, seule une réinstallation est nécessaire.

### Ajouter des extensions

Flarum ne permet pas encore d'installer des extensions depuis son interface d'administration ; vous devrez donc utiliser la ligne de commande.

Remplacez `flarum` par l'ID de votre app en cas de multiple installations.
Remplacez `vendor/extension` par les noms adéquats. Référez-vous à la documentation de l'extension pour vérifier qu'elle ne nécessite pas de configuration supplémentaire.

```bash
sudo su
app=flarum
cd /var/www/$app
sudo -u $app php7.3 composer.phar require vendor/extension
```

#### Dépannage

##### Erreurs de `timeout`
Quelques utilisateurs rapportent qu'ils font fassent à une page blanche due à une erreur de `timeout` dans un script PHP qui prépare le cache (`Minify.php`, notamment).

Dans `/etc/php/*php_version*/fpm/pool.d/*app_id*.conf`, vous pouvez augmenter les limites `max_execution_time` et `max_input_time` (les deux valeurs sont en secondes si vous ne précisez pas d'unité).

Rechargez PHP-FPM avec `sudo service php*php_version*-fpm reload`.

##### Limite de téléversement
Si vous avez une erreur lors du chargement de gros fichiers dans le forum, PHP pourrait être en train de limiter les téléversements.

Dans `/etc/php/*php_version*/fpm/pool.d/*app_id*.conf`, vous pouvez décommenter (enlevez `;` au début de la ligne) et augmenter les valeurs de `upload_max_filesize` de `post_max_size` (les deux valeurs sont en octets).

Rechargez PHP-FPM avec `sudo service php*php_version*-fpm reload`.

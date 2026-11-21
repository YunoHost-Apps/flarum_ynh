### Connexion

Cette app permet à vos utilisateurs enregistrés dans YunoHost de se connecter en passant par une autre app, Dex.

Vous pouvez modifier le texte, l'îcone, et les couleurs du bouton de connextion dans les paramètres de l'extension OIDC.

### Mise à jour

Notez que, pour le moment, toute extension tierce est désinstallée lors d'une mise à jour.
Leurs données et paramètres restent dans la base de donnée de Flarum, seule une réinstallation est nécessaire.

### Ajouter des extensions

Flarum ne permet pas encore d'installer des extensions depuis son interface d'administration ; vous devrez donc utiliser la ligne de commande.

Remplacez `vendor/extension` par les noms adéquats. Référez-vous à la documentation de l'extension pour vérifier qu'elle ne nécessite pas de configuration supplémentaire.

```bash
sudo su
app=__ID__
cd /var/www/$app
sudo -u $app php__PHP_VERSION__ composer.phar require vendor/extension
```

#### Dépannage

##### Erreurs de `timeout`
Quelques utilisateurs rapportent qu'ils font fassent à une page blanche due à une erreur de `timeout` dans un script PHP qui prépare le cache (`Minify.php`, notamment).

Dans `/etc/php/__PHP_VERSION__/fpm/pool.d/__ID__.conf`, vous pouvez augmenter les limites `max_execution_time` et `max_input_time` (les deux valeurs sont en secondes si vous ne précisez pas d'unité).

Rechargez PHP-FPM avec `sudo service php__PHP_VERSION__-fpm reload`.

##### Limite de téléversement
Si vous avez une erreur lors du chargement de gros fichiers dans le forum, PHP pourrait être en train de limiter les téléversements.

Dans `/etc/php/__PHP_VERSION__/fpm/pool.d/__ID__.conf`, vous pouvez décommenter (enlevez `;` au début de la ligne) et augmenter les valeurs de `upload_max_filesize` de `post_max_size` (les deux valeurs sont en octets).

Rechargez PHP-FPM avec `sudo service php__PHPVERSION__-fpm reload`.

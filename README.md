[![Build Status](https://git.itz.uni-halle.de/elearning/ilias-docker/badges/master/build.svg)](https://git.itz.uni-halle.de/elearning/studip_vanilla/commits/master)

# Stud.IP 4.1 in Docker

Ein leeres Stud.IP 4.1 für Vorarbeiten zum Update.


## Vorbemerkungen
Werden alle Images dieses Repos gebaut und als Container gestartet, existieren danach 
ein NGINX ein PHP-FPM, ein mariadb und ein MKDOCS Container.
Die Ports des Datenbankservers und von PHP-FPM werden nicht exposed. 
NGINX und PHP-FPM sowie MariaDB und PHP-FPM kommunizieren über die von Docker generierte Bridge.
Nur die Ports für http und ggf. https werden exposed.

Es existieren drei Volumes in `./volumes/`:
1. log/nginx bzw. log/php-fpm - wird in den PHP-FPM und NGINX Container gemappt. Darin legen diese Dienste ihre Logdateien ab
2. mysql-data - ist vor dem ersten Start des mariadb Containers leer. Darin legt der Datenbankserver des MariaDB Containers seine Daten ab.

Der MariaDB Container ist vor allem für Testinstallationen mit lokaler Datenbank sinnvoll. 
Wird der zentrale MySQL-Server benutzt, muss er nicht gebaut oder gestartet werden. 
Soll der MariaDB-Container mit einer leeren Datenbank neu aufgesetzt werden, muss der Inhalt von `./volumes/mysql-data/` gelöscht werden.

Soll ein Abbild eines schon vorhandenen Stud.IPs generiert werden, müssen die Quelldateien 
in `./assets/studip-release/4.0/` liegen und ein Datenbankdump in `./assets/mysql/docker-entrypoint-initdb.d/`. 
Die für eine Testinstallation schon in `./assets/mysql/docker-entrypoint-initdb.d/` vorhandenen sql-Dateien müssen in diesem Fall vorher gelöscht werden.

In `./assets/nginx/ssl/` liegen ungültiges Zertifikat und Serverkey. Diese müssen für sichere SSL-Verbindungen mit validen Dateien ersetzt werden.

## Quickstart

### Testinstanz

Eine leere Instanz von Studip 4.0 mit Containern für NGINX, PHP-FPM und MariaDB. Die Daten für den MariaDB Container müssen nicht verändert werden. 
In diesem Fall wären dann aber die Credentials für die Datenbank allgemein bekannt.

1. Repo klonen
2. env.example nach .env kopieren
3. die wichtigsten Parameter für den Webserver konfigurieren
    * STUDIP_MAIL_HOST_NAME
    * NGINX_SERVER_NAME
    * NGINX_HOST_PORT
    * NGINX_SSL_ENABLED
    * NGINX_HOST_SSL_PORT
4. Optional die Benutzer und Passwörter für den mysql Container setzen
    * MYSQL_ROOT_PASSWORD
    * MYSQL_DATABASE
    * MYSQL_USER
    * MYSQL_PASSWORD
5. Stud.IP auschecken
```bash
svn checkout --username=studip --password=studip --non-interactive svn://develop.studip.de/studip/branches/4.1/ ./assets/studip-release/4.1
```

Alternativ kann man auch den Trunk mit dem aktuellen Entwicklungsstand auschecken:
```bash
svn checkout --username=studip --password=studip --non-interactive svn://develop.studip.de/studip/branches/4.1/ ./assets/studip-release/4.1
```


6. `docker-compose build`
7. `docker-compose up -d`

Die Installation sollte nach einer Weile unter http(s)://[NGINX_SERVER_NAME]:[NGINX_HOST_(SSL_)PORT]/ erreichbar sein. 
Das erste Initialisieren der Datenbank dauert selbst für die Testdatenbank eine Weile (~ einige Minuten). 
Wird der Build während dieser Initialisierung unterbrochen, liegen keine konsistenten Daten für die Datenbank vor. 
In diesem Fall muss der Inhalt von `./volumes/mysql-data/` vor dem nächsten Build gelöscht werden.

```bash
docker-compose logs -f mariadb
```

verfolgt werden. Die Datenbank ist bereit wenn als eine der letzten Meldungen `mysqld: ready for connections` erscheint 
und das Webinterface nicht mehr die Fehlermeldung ausgibt, dass die Datenbank nicht erreichbar sei.


## TODO
### Database
 * Collation richtig? [siehe auch](http://docs.studip.de/admin/Admins/Installationsanleitung)
 * Snakeoil-Zertifikatgenerierung hinzufügen
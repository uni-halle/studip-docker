## mariadb container

### Initialisierung des Containers

Wenn sich im Datenbankverzeichnis des mariadb-Containers keine Dateien befinden, 
wird eine leere Datenbank angelegt. Für das Bauen von Testsystemen ist es also
sinnvoll, den Ordner `volumes/mariadb/` leer zu lassen.

Liegen in diesem Ordner schon Dateien einer Datenbank wird mariadb mit diesen gestartet.


### Initialisierung der Datenbank

Der Verlauf der Datenbankinitialisierung kann mit Hilfe von SQL-Dumps, 
die im Verzeichnis `/docker-entrypoint-initdb.d/` im mariadb-Container liegen, 
beeinflusst werden. Die sich darin befindenden Dateien mit dem 
Suffix `sql` werden in Alphabetischer Reihenfolge ausgeführt (siehe auch [Dokumentation des Images](https://hub.docker.com/_/mariadb/).

Stud.IP weißt in der [Installationsanleitung](http://docs.studip.de/admin/Admins/Installationsanleitung#toc13) 
auf einige einige Beispieldateien hin. Diese Beispieldateien liegen auf dem Host in `assets/mysql/docker-entrypoint-initdb.d/` 
und sind mit Präfixen  (<BUCHSTABE\>_) versehen, die die Reihenfolge 
der Ausführung festlegen. Im Einzelnen sind das diese Dateien

Dateiname | Funktion | Notwendig
--------- | -------- | ---------
a_studip.sql | Datenbankschema | Ja
b_studip_default_data.sql | Voreinstellungen für Stud.IP | Ja
c_studip_resources_default_data.sql | Voreinstellungen für Ressourcenverwaltung | Ja wenn Ressourcenvwerwaltung gewünscht
d_studip_root_user.sql | Anlegen eines Benutzers `root@studip` mit Passwort `testing` für Webfrontend | Ja, alternativ mit mysql Client zu Fuß
o_studip_demo_data.sql | Demo Daten für Stud.IP | Nein
o_studip_resources_demo_data.sql | Demo Daten für Ressourcenverwaltung | Nein

Die Originale dieser Dateien stammen aus dem Verzeichnis `db` im Stud.IP Release-Ordner.

Das initialisieren einer leeren Datenbank kann nach dem ersten Containerstart eine Weile 
(~ wenige Minuten) dauern. Wenn in Studip gleich nach der Installation Fehler ausgegeben
werden kann dies der Grund sein.

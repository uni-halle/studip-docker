## mariadb container

### Initialisierung

Wenn sich im Datenbankverzeichnis des mariadb-Containers keine Dateien befinden, wird eine leere Datenbank angelegt.

Der Verlauf der Initialisierung kann mit Hilfe von SQL-Dumps, die im Verzeichnis `/docker-entrypoint-initdb.d/` im mariadb-Container liegen, beeinflusst werden. Die sich darin befindenden Dateien mit dem Suffix `sql` werden in Alphabetischer Reihenfolge ausgeführt. Stud.IP stellt unter <http://docs.studip.de/admin/Admins/Installationsanleitung#toc13> einige Beispieldateien zur Verfügung.

## Weiterführende Links
[1] <https://hub.docker.com/_/mariadb/>

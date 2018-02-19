## Installation

### `.env`-Datei anlegen und anpassen

```
$ cp .env.example .env
$ vi .env
```

### Vorbereitung des Builds

#### Stud.IP Dateien herunterladen
   Solange es kein Release für Studip 4 gibt, Quellen im Verzeichnis assets/studip-release auschecken

```
cd assets/studip-release/
svn checkout svn://develop.studip.de/studip/branches/4.0/
cd ../../
```

#### Projekt bauen und starten

   Im Root des Projektverzeichnis:

```
docker-compose build && docker-compose up -d
```

## Installation

### `.env`-Datei anlegen und anpassen

   $ cp .env.example .env
   $ vi .env


### Vorbeireitung des Builds

#### Stud.IP Dateien herunterladen
   Solange es kein Release für Studip 4 gibt sourcen im Verzeichnis assets/studip-release auschecken
   $ svn svn checkout svn://develop.studip.de/studip/branches/4.0/

#### Projekt bauen und starten
   $ docker-compose build && docker-compose up -d


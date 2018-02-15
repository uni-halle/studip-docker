# Stud.IP 4.0

Technische Dokumentation von Stud.IP 4.0. 

Diese Dokumentation enthält allgemeine Informationen zum Aufbau und der Funktionalität des Stud.IP 4 Docker Basisimages.

## Installation

Siehe [Installation](installation.md).

## Betrieb (Operations)

???

## Images

Vgl. `docker-compose.yaml`

* **[mariadb](mariadb.md)**: Standard-Mariadb-Datenbank-Container
* **[nginx](nginx.md)**: Reverse-Proxy und Static http Server inkl. https.
* **[php-fpm](php-fpm.md)**: Standard php-fpm 7 Container.

## Volumes Layout

Der Speicherpfad der Volumes wird in der `.env`-Datei unter `VOLUMES_PATH` definiert.

    .
    ├── log/nginx                   # Log-Verzeichnis von nginx
    ├── log/php-fpm                 # Log-Verzeichnis von php
    └── mysql-data                  # mariadb Datenbankverzeichnis

## Assets

    .
    ├── mysql/docker-entrypoint-initdb.d  # SQL dumps für Datenbankinitialisierung
    ├── nginx/...                         # Konfigurationsdateien für nginx
    ├── php-fpm                           # Konfigurationsdateien für php
    └── studip-release                    # enthält die Dateien des Studip Releases


## Project Layout

    .
    ├── .env                        # Hostspezifische Konfiguration
    ├── .env.example                # Hostspezifische Beispielkonfiguration
    ├── .dockerignore               # Dateien/Verzeichnisse, die beim Bauen von Images ignoriert werden
    ├── .gitignore                  # Dateien, die nicht unter Versionskontrolle stehen
    ├── .gitlab-ci.yml              # Konfiguration des Integration/Deployments mit Gitlab
    ├── docker-compose.yaml         # Services (Container)
    ├── nginx.dockerfile            # nginx Dockerfile
    ├── mariadb.dockerfile          # mariadb Dockerfile
    ├── php-fpm.dockerfile          # php-fpm Dockerfile
    ├── docs                        # MkDocs-Dokumentation
    ├── mkdocs.yml                  # MkDocs-Config
    ├── README.md
    ├── Taskfile                    # Tasks (TODO)
    └── taskit                      # Runner für Tasks (TODO)


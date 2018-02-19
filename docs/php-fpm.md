## php-fpm container


### Installation
Für das Funktionieren des Containers müssen die Variablen in der .env - Datei gesetzt werden.

### Performance
In der .env-Datei können und sollten die Parameter für die Anzahl der php-fpm-Worker gesetzt werden. 
Diese Parameter sind abhängig vom Arbeitsspeicher, den php für den Ablauf von Stud.IP benötigt.

Ist diese Größe unbekannt, muss sie in einem laufenden PHP-FPM Container bestimmt werden:

```
$ docker-compose exec php-fpm bash
root@a5a75f512e70:# ps -ylC php-fpm --sort:rss
S   UID   PID  PPID  C PRI  NI   RSS    SZ WCHAN  TTY          TIME CMD
S    33    16     1  0  80   0 25196 55730 -      ?        00:00:00 php-fpm
S     0     1     0  0  80   0 25240 55083 SyS_ep ?        00:00:00 php-fpm
S    33    19     1  0  80   0 27220 56223 -      ?        00:00:00 php-fpm
S    33    18     1  0  80   0 27392 56225 -      ?        00:00:00 php-fpm
S    33    13     1  0  80   0 28104 56255 -      ?        00:00:00 php-fpm
S    33    14     1  0  80   0 28148 56232 -      ?        00:00:01 php-fpm
S    33    15     1  0  80   0 29496 56257 -      ?        00:00:00 php-fpm
S    33    17     1  0  80   0 29940 56241 -      ?        00:00:00 php-fpm
S    33    20     1  0  80   0 30184 56541 -      ?        00:00:00 php-fpm
```

Die Werte in der Spalte `RSS` ([Resident Set Size](https://en.wikipedia.org/wiki/Resident_set_size))
geben den für einen PHP-FPM-Prozess notwendigen Arbeitsspeicher (in Bytes) wieder und sind 
entscheident für die Anzahl der möglichen PHP-Prozesse. Es ist sinnvoll hier 
den größten Wert als Richtmaß für die Berechnung der Anzahl zu nutzen. In diesem Beispiel
sind das etwa 30 Megabyte. Diese Größe multipliziert mit der maximalen Anzahl der PHP-Prozesse
muss in den dafür vorgesehenen Arbeitsspeicher passen.

Sollen also 3 Gigabyte für PHP-FPM genutzt werden, können in diesem Fall etwa 100 PHP-FPM-Prozesse
gleichzeitig laufen. Dann könnte man die Parameter in der .env-Datei wie folgt setzen:

* PHP_PM_MAX_CHILDREN=100 (3GB / 30 MB)
* PHP_PM_START_SERVERS=10 (Die Anzahl von Prozessen beim Neustart)
* PHP_PM_MIN_SPARE_SERVERS=10 (Die Minimale Anzahl von unbeschäftigten Reserveprozessen, die PHP permanent bereit halten soll)
* PHP_PM_MAX_SPARE_SERVERS=20 (Die Maximale Anzahl der unbeschäftigten Reserveprozesse.)


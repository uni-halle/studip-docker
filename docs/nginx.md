## nginx container


### SSL
Zertifikate für SSL müssen in `assets/nginx/conf/ssl/` kopiert werden. Die Standardkonfiguration erwartet die Dateien `studip.chain.pem` und `studip.key`.


### Besonderheit path_info

Im Template der nginx Konfigurationsdatei wird im Kontext des Forwarding an php ein [fastcgi_split_path_info](http://nginx.org/en/docs/http/ngx_http_fastcgi_module.html#fastcgi_split_path_info) ausgeführt.
Dadurch wird die URL in den Teil bis einschließlich ".php" und den Teil danach getrennt. Der Zweite Teil der URL, der von Stud.IP auch benötigt wird wird in der Variable `fastcgi_path_info` gespeichert. 
Danach erfolgt mit [try_files](http://nginx.org/en/docs/http/ngx_http_core_module.html#try_files) der Test auf Existenz des php Scriptes.

`try_files` löscht dabei den Inhalt der Variable `$fastcgi_path_info`. In der Folge bekommen die Stud.IP-PHP-Scripte nicht mehr alle nötigen Informationen.
Deshalb wird vor dem Ausführen von `try_files` der Inhalt von `$fastcgi_path_info` nach `$path_info` kopiert. In der Datei `fastcgi_params` der fastcgi_param `PATH_INFO` nicht auf `$fastcgi_path_info` gesetzt sondern auf `$path_info`.



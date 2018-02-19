#!/usr/bin/env bash

set -e

echo 'Configuring PHP-FPM ...'
envsubst \
	< /usr/local/etc/php-fpm.d/www.conf.template \
	> /usr/local/etc/php-fpm.d/www.conf

echo 'Configuring SSMPT for sending Mail ...'
echo FIXME
#envsubst \
#        < /etc/ssmtp/ssmtp.conf.template \
#        > /etc/ssmtp/ssmtp.conf

echo 'Configuring Stud.IP'
envsubst \
    '${MYSQL_HOST} ${MYSQL_USER} ${MYSQL_PASSWORD} ${MYSQL_DATABASE}' \
    < ${PHP_FPM_WEB_ROOT}/config/config_local.inc.php.template \
    > ${PHP_FPM_WEB_ROOT}/config/config_local.inc.php
envsubst \
    '${NGINX_PROTOCOL} ${NGINX_SERVER_NAME} ${NGINX_HOST_PORT}' \
    < ${PHP_FPM_WEB_ROOT}/config/config.inc.php.template \
    > ${PHP_FPM_WEB_ROOT}/config/config.inc.php


echo 'Setting logs directory permission ...'
mkdir -p /var/log/studip
chown -R www-data /var/log/studip
chmod u+w /var/log/studip


if [ "$STUDIP_SET_DD_PERMISSION" = true ] || [ "$STUDIP_FRESH_INSTALL" = true ]; then
	echo 'Setting data directory permission ...'
	echo '[This may take a while.]'
	chown -R -v www-data ${PHP_FPM_WEB_ROOT}
	chmod u+r ${PHP_FPM_WEB_ROOT}
else
	echo 'Skip setting data directory permission'
fi


cd "$prev_dir"

echo "Starting php-fpm ...: $@"
exec docker-php-entrypoint "$@"

echo 'php-fpm exited'


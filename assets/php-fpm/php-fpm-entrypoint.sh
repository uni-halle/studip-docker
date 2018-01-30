#!/usr/bin/env bash

set -e

prev_dir="$PWD"
cd /usr/local/studip/public

#chown -v -R www-data /usr/local/studip

echo 'Configuring PHP-FPM ...'
echo FIXME
#envsubst \
#	< /usr/local/etc/php/conf.d/studip.ini.template \
#	> /usr/local/etc/php/conf.d/studip.ini

echo 'Configuring SSMPT for sending Mail ...'
echo FIXME
#envsubst \
#        < /etc/ssmtp/ssmtp.conf.template \
#        > /etc/ssmtp/ssmtp.conf

echo 'Setting logs directory permission ...'
mkdir -p /var/log/studip
chown -R www-data /var/log/studip
chmod u+w /var/log/studip


if [ "$STUDIP_SET_DD_PERMISSION" = true ] || [ "$STUDIP_FRESH_INSTALL" = true ]; then
	echo 'Setting data directory permission ...'
	echo '[This may take a while.]'
	chown -R -v www-data /usr/local/studip/data
	chmod u+r /usr/local/studip/data
else
	echo 'Skip setting data directory permission'
fi


cd "$prev_dir"

echo "Starting php-fpm ...: $@"
exec docker-php-entrypoint "$@"

echo 'php-fpm exited'


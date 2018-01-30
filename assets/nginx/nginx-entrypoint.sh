#!/usr/bin/env bash

set -e

export STUDIP_SSL_CONFIG="	listen 80;"
export STUDIP_HTTPS_REDIRECT_CONFIG=""

if [ "$NGINX_FORCE_HTTPS" = true ] && ! [ "$NGINX_SSL_ENABLED" = true ]; then
	echo "Inconsistent NGINX configuration detected:"
	echo "Can't FORCE_HTTPS when SSL_ENABLED isn't true."
	echo "Check your .env file! Exiting now."
	exit 1
fi

if [ "$NGINX_FORCE_HTTPS" = true ] && [ "$NGINX_PROTOCOL" = "http" ]; then
	echo "Inconsistent NGINX configuration detected:"
	echo "NGINX_PROTOCOL defaults to http while attempting to FORCE_HTTPS"
	echo "Check your .env file! Exiting now."
	exit 1
fi

if [ "$NGINX_SSL_ENABLED" = true ]; then
	export STUDIP_SSL_CONFIG="
	listen 443 ssl;

	ssl_certificate      /etc/nginx/ssl/studip.chain.pem;
	ssl_certificate_key  /etc/nginx/ssl/studip.key;
"

	if [ "$NGINX_FORCE_HTTPS" = true ]; then
		# Listen for TLS encrypted traffic on port 80
		# If traffic arrives that is encrypted,
		# redirect to the SSL-Port; and do the same
		# when unencrypted traffic arrives via an error_page
		# handler
		# https://serverfault.com/a/664936
		# Why? Because
		#   http://host:80   ---(HSTS)---> https://host:443
		#   http://host:8080 ---(HSTS)---> https://host:8080
		# Thus, if HSTS is enabled and you want to run studip
		# default plain HTTP on :8080 and HTTPS on :8443 with
		# HSTS enabled, http://host:8080 will fail after the
		# browser has enabled HSTS for the host because it would
		# try connect to https://host:8080 without HTTPS being
		# supported on :8080
		# N.b. the ports are configured through the docker proxy.
		# Internally, in this image we just use 80 and 443 for
		# studip.
		# We use a 307 redirect here so login from other sources
		# should just work as it did before.
		# 307 means: Temporary redirect, but preserve the request
		# method. 308 (permanent) would be better but browser
		# support is unknown. It was introduced in 2014.
		# Anyway, that story about temporary vs. permanent is not
		# a big deal as most browsers will cache the HSTS response
		# header and apply it to future requests.
                export studip_HTTPS_REDIRECT_CONFIG="
server {
	listen         80 ssl;

        ssl_certificate      /etc/nginx/ssl/studip.chain.pem;
        ssl_certificate_key  /etc/nginx/ssl/studip.key;

	server_name    $NGINX_SERVER_NAME;
	error_page 497 301 =307 https://\$server_name:$NGINX_HOST_SSL_PORT\$request_uri;
	return         307 https://\$server_name:$NGINX_HOST_SSL_PORT\$request_uri;
}"
                export STUDIP_SSL_CONFIG="$STUDIP_SSL_CONFIG
	add_header Strict-Transport-Security \"max-age=31536000\";
"
	else
		export STUDIP_SSL_CONFIG="$STUDIP_SSL_CONFIG
	listen 80;
"
	fi

	export ETHERPAD_SSL_CONFIG="
	listen        8080 ssl;

	ssl_certificate      /etc/nginx/ssl/studip.chain.pem;
	ssl_certificate_key  /etc/nginx/ssl/studip.key;
"
fi

echo 'substituting variables in nginx configuration'
envsubst \
	'${NGINX_SERVER_NAME} ${PHP_FPM_PORT} ${STUDIP_MAX_EXECUTION_TIME}
	 ${STUDIP_SSL_CONFIG} ${STUDIP_HTTPS_REDIRECT_CONFIG}' \
	< /etc/nginx/conf.d/studip.conf.template \
	> /etc/nginx/conf.d/studip.conf

if [ "$STUDIP_SET_DD_PERMISSION" = true ]; then
	echo 'Setting data directory permission.'
	echo 'This may take a while.'
	chgrp -R nginx /var/www/studip/data
	chmod -R g+r /var/www/studip/data
	find /var/www/studip/data -type d -exec chmod g+s  {} \;
else
	echo 'Skip setting data directory permission'
fi

echo "starting nginx ...: $@"
exec "$@"
echo 'nginx exited'


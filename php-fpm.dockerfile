FROM php:7.0-fpm

ARG TZ
ARG BUILD_NO
ARG PHP_FPM_WEB_ROOT

# Update durchführen
RUN \
        apt-get update && \
        apt-get upgrade -y


# Zeitzone festlegen
RUN \
        echo ${TZ} > /etc/timezone && \
        dpkg-reconfigure -f noninteractive tzdata


# because https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=863199
RUN mkdir -p /usr/share/man/man1

# Benoetigte Pakete installieren

RUN \
	apt-get -y install default-jre default-jre-headless gettext-base\
	           mc

# informationen zu den benötigten Paketen: http://zgadzaj.com/how-to-install-php-53-and-52-together-on-ubuntu-1204
RUN \
	apt-get install -y fop libxslt1-dev libcurl4-openssl-dev \
	                   libmcrypt-dev zip libzip-dev libzip2 libbz2-dev \
                           libssl-dev libjpeg-dev libpng-dev mariadb-client\
                           libfreetype6-dev libjpeg62-turbo-dev libxslt1-dev\
                           libmcrypt-dev curl libtidy-dev libldap2-dev \
                           unzip \
	&& rm -r /var/lib/apt/lists/*



# PHP-Erweiterungen installieren
RUN \
	docker-php-ext-install -j$(nproc) xsl iconv dom pdo  mysqli \
	pdo_mysql json soap curl bcmath zip bz2 mbstring pcntl \
	opcache gettext session ftp xml  \
	&& docker-php-ext-configure gd --with-freetype-dir=/usr/include/ \
	--with-jpeg-dir=/usr/include/ \
	&& docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
	&& docker-php-ext-install -j$(nproc) gd ldap \
	&& pear install XML_RPC2 mail HTTP_Request2 Auth DB HTML_Template_IT \
	MDB2

COPY assets/php-fpm/php-fpm-entrypoint.sh /php-fpm-entrypoint.sh
COPY --chown=www-data:www-data assets/studip-release/4.0 /var/www/studip
COPY assets/php-fpm/config_local.inc.php.template /var/www/studip/config/config_local.inc.php.template
COPY assets/php-fpm/config.inc.php.template /var/www/studip/config/config.inc.php.template

#RUN chown -R www-data:www-data ${PHP_FPM_WEB_ROOT}

RUN mkdir -p /var/log/php && chown www-data:www-data /var/log/php

# Einstiegspunkt setzen
ENTRYPOINT ["/php-fpm-entrypoint.sh"]
CMD ["php-fpm"]
WORKDIR ${PHP_FPM_WEB_ROOT}


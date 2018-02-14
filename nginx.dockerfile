FROM nginx:stable

ARG TZ
ARG BUILD_NO

# Update durchführen
RUN \
	apt-get update && \
	apt-get upgrade -y

# Zeitzone festlegen
RUN \
	echo ${TZ} > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

# Benoetigte Pakete installieren
RUN \
	apt-get install -y ca-certificates openssl tree

COPY "assets/nginx" "/assets"

# abschließende Konfiguration
RUN \
	cd /assets \
	&& mv nginx-entrypoint.sh / \
	&& chmod u+x /nginx-entrypoint.sh \
	&& cp -a conf/* /etc/nginx/ \
	&& rm /etc/nginx/conf.d/default.conf \
	&& cd .. && rm -r assets

COPY assets/studip-release/4.0/public /var/www/studip/public
COPY assets/nginx/nginx-error-pages/studip-docker_504.html /var/www/studip/public/504.html
COPY assets/nginx/nginx-error-pages/studip-docker_502.html /var/www/studip/public/502.html

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx"]
WORKDIR /var/www/studip


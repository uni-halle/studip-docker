FROM nginx:stable

ARG TZ
ARG BUILD_NO
ARG NGINX_WEB_ROOT

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

COPY --chown=www-data:www-data assets/studip-release/4.0/public ${NGINX_WEB_ROOT}
COPY --chown=www-data:www-data assets/nginx/nginx-error-pages/studip-docker_504.html ${NGINX_WEB_ROOT}/504.html
COPY --chown=www-data:www-data assets/nginx/nginx-error-pages/studip-docker_502.html ${NGINX_WEB_ROOT}/502.html

ENTRYPOINT ["/nginx-entrypoint.sh"]
CMD ["nginx"]
WORKDIR ${NGINX_WEB_ROOT}


FROM mariadb:10

COPY assets/mysql/docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

ARG TZ
ARG BUILD_NO


# Zeitzone festlegen
RUN \
	echo ${TZ} > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

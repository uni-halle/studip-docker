FROM mariadb:10

COPY assets/mysql/docker-entrypoint-initdb.d /docker-entrypoint-initdb.d

ARG TZ
ARG BUILD_NO

# Update durchführen
#RUN \
#	apt-get update && \
#	apt-get upgrade -y

# Zeitzone festlegen
RUN \
	echo ${TZ} > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata



#RUN mysql -u root -p ${MYSQL_ROOT_PASSWORD} -e "CREATE DATABASE ${MYSQL_DATABASE} DEFAULT CHARACTER SET latin1 COLLATE latin1_german1_ci"

#RUN mysql -u root -p ${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /studip_db_setup/studip.sql

#RUN mysql -u root -p ${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /studip_db_setup/studip_root_user.sql

#RUN mysql -u root -p ${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /studip_db_setup/studip_default_data.sql

#RUN mysql -u root -p ${MYSQL_ROOT_PASSWORD} ${MYSQL_DATABASE} < /studip_db_setup/studip_resources_default_data.sql


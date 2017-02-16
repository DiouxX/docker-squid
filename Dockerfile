#Choose Debian
FROM debian:latest

MAINTAINER DiouxX "github@diouxx.be"

#Don't ask questions during install
ENV DEBIAN_FRONTEND noninteractive

#Install Squid3
RUN apt update \
&& apt -y upgrade \
&& apt -y install nano squid3

#Ports
EXPOSE 3128

VOLUME ["/etc/squid3"]

#Copy and run install script
COPY ldap.config /opt/
COPY squid-start.sh /opt/
RUN chmod +x /opt/squid-start.sh
ENTRYPOINT ["/opt/squid-start.sh"]

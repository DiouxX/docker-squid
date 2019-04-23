#Choose Debian
FROM debian:latest

LABEL maintainer="DiouxX - github@diouxx.be"

#Don't ask questions during install
ENV DEBIAN_FRONTEND noninteractive

#By default, Squid is on open proxy
ENV LDAP_ENABLE=false

#Install Squid3
RUN apt update \
&& apt -y install ca-certificates squid3

#Ports
EXPOSE 3128

VOLUME ["/etc/squid"]

#Copy and run install script
#COPY ldap.config /opt/
COPY squid-start.sh /opt/
RUN chmod +x /opt/squid-start.sh
ENTRYPOINT ["/opt/squid-start.sh"]

# Project to deploy Squid3 with docker

Install and run an Squid3 instance with docker.

You can use LDAP authentication or like an open proxy

## Deploy Squid3
```sh
docker run --name squid -p 3128:3128 -d diouxx/squid3
```

## Settings

For change settings, run a terminal into container
```sh
docker exec -it squid /bin/bash
```
And edit */opt/ldap.config* file
```sh
nano /opt/ldap.config
```

* LDAP_ENABLE= true or false to enable LDAP authentication
* LDAP_HOST= LDAP IP or domain name
* LDAP_PORT= 389 or 636 for LDAPS
* LDAP_DN= DN LDAP
* LDAP_ATTRIBUT=LDAP scope
* PROXY_NAME="Proxy Name to display"

Restart container
```sh
docker restart squid
```

## Deploy with docker-compose

You can deploy squid docker with docker-compose.

* First, create docker-compose.yml
```
#SQUID Container
squid:
  image: diouxx/squid
  container_name: squid
  hostname: squid
  ports:
    - "3128:3128"
  restart: always
````

To deploy, just run the following command on the same directory as file

```sh
docker-compose up -d
````
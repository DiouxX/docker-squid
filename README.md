# Project to deploy Squid3 with docker

- [Project to deploy Squid3 with docker](#project-to-deploy-squid3-with-docker)
- [Introduction](#introduction)
- [Deploy witch CLI](#deploy-witch-cli)
  - [Deploy Squid on open proxy](#deploy-squid-on-open-proxy)
  - [Deploy Squid with LDAP Authentication](#deploy-squid-with-ldap-authentication)
    - [LDAP](#ldap)
    - [LDAPS](#ldaps)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy Squid on open proxy (for quickly test)](#deploy-squid-on-open-proxy-for-quickly-test)
  - [Deploy Squid with LDAP Authentication](#deploy-squid-with-ldap-authentication-1)
    - [LDAP](#ldap-1)
    - [LDAPS](#ldaps-1)

# Introduction

Install and run an Squid3 instance with docker.

You can use LDAP authentication or like an open proxy

# Deploy witch CLI

## Deploy Squid on open proxy

```sh
docker run --name squid --hostname squid -p 3128:3128 -d diouxx/squid
```

## Deploy Squid with LDAP Authentication
### LDAP

```sh
docker run --name squid --hostname squid -e LDAP_ENABLE=true -e LDAP_HOST=yourldap.domain.com -e LDAP_PORT=389 -e LDAP_DN="ou=Users,dc=yourdomain,dc=com" -e LDAP_ATTRIBUT="uid=%s" -e PROXY_NAME="Proxy Display Name" -p 3128:3128 -d diouxx/squid
```

### LDAPS

```sh
docker run --name squid --hostname squid -e LDAP_ENABLE=true -e LDAP_HOST=yourldap.domain.com -e LDAP_PORT=636 -e LDAP_DN="ou=Users,dc=yourdomain,dc=com" -e LDAP_ATTRIBUT="uid=%s" -e PROXY_NAME="Proxy Display Name" -p 3128:3128 -d diouxx/squid
```

# Deploy with docker-compose

You can deploy squid docker with docker-compose.

## Deploy Squid on open proxy (for quickly test)

```yaml
version: '3.2'

services: 
  squid:
    image: squid
    container_name: squid
    hostname: squid
    ports:
      - "3128:3128"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    restart: always
```

## Deploy Squid with LDAP Authentication
### LDAP

```yaml
version: '3.2'

services: 
  squid-test:
    image: squid-test
    container_name: squid-test
    hostname: squid-test
    ports:
      - "3128:3128"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment: 
      - LDAP_ENABLE=true
      - LDAP_HOST=yourldap.domain.com
      - LDAP_PORT=389
      - LDAP_DN="ou=Users,dc=yourdomain,dc=com"
      - LDAP_ATTRIBUT="uid=%s"
      - PROXY_NAME="Proxy Display Name"
    restart: always
```

### LDAPS

```yaml
version: '3.2'

services: 
  squid-test:
    image: squid-test
    container_name: squid-test
    hostname: squid-test
    ports:
      - "3128:3128"
    volumes:
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    environment: 
      - LDAP_ENABLE=true
      - LDAP_HOST=yourldap.domain.com
      - LDAP_PORT=636
      - LDAP_DN="ou=Users,dc=yourdomain,dc=com"
      - LDAP_ATTRIBUT="uid=%s"
      - PROXY_NAME="Proxy Display Name"
    restart: always
```

To deploy, just run the following command on the same directory as file

```sh
docker-compose up -d
```

# Project to deploy Squid with docker

- [Project to deploy Squid with docker](#project-to-deploy-squid-with-docker)
- [Introduction](#introduction)
- [Deploy witch CLI](#deploy-witch-cli)
  - [Deploy Squid on open proxy mode](#deploy-squid-on-open-proxy-mode)
  - [Deploy Squid with LDAP Authentication](#deploy-squid-with-ldap-authentication)
    - [LDAP](#ldap)
    - [LDAPS](#ldaps)
- [Deploy with docker-compose](#deploy-with-docker-compose)
  - [Deploy Squid on open proxy mode](#deploy-squid-on-open-proxy-mode-1)
  - [Deploy Squid with LDAP Authentication](#deploy-squid-with-ldap-authentication-1)
    - [LDAP](#ldap-1)
    - [LDAPS](#ldaps-1)
- [Environment varibales](#environment-varibales)
  - [LDAP_ENABLE](#ldapenable)
  - [LDAP_HOST](#ldaphost)
  - [LDAP_PORT](#ldapport)
  - [LDAP_DN](#ldapdn)
  - [LDAP_ATTRIBUT](#ldapattribut)
  - [PROXY_NAME](#proxyname)

# Introduction

Install and run an Squid instance with docker.

You can use LDAP authentication or like an open proxy

By default, if you don't set environment variable, Squid is on open proxy mode

# Deploy witch CLI

## Deploy Squid on open proxy mode

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

## Deploy Squid on open proxy mode

```yaml
version: '3.2'

services: 
  squid:
    image: diouxx/squid
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
  squid:
    image: diouxx/squid
    container_name: squid
    hostname: squid
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
  squid:
    image: diouxx/squid
    container_name: squid
    hostname: squid
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

# Environment varibales

## LDAP_ENABLE

It use to enable LDAP Authentication. By default, it is set to false
To enable, just set to true

```
LDAP_ENABLE=true
```

## LDAP_HOST

Only use if LDAP_ENABLE is set to true

Specifies the LDAP host to contact for authentication.
In the form of DNS names or IP addresses

```
LDAP_HOST=yourldap.domain.com
```

## LDAP_PORT

Only use if LDAP_ENABLE is set to true

Specifie the LDAP server port.
By convention :
* 389 to LDAP
* 636 to LDAPS

```
LDAP_PORT=636
```

## LDAP_DN

Only use if LDAP_ENABLE is set to true

Specifies Distinguish Name where user is registered

```
LDAP_DN="ou=Users,dc=yourdomain,dc=com"
```

## LDAP_ATTRIBUT

Only use if LDAP_ENABLE is set to true

Specifies LDAP attribut for users authentication

```
LDAP_ATTRIBUT="uid=%s"
```

## PROXY_NAME

Only use if LDAP_ENABLE is set to true

Set Display Name for your proxy

```
PROXY_NAME="Your Proxy Display Name"
```

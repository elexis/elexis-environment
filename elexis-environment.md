# Elexis-Environment v0.1

An integrated Elexis environment providing elexis-server, ldap, wiki and a chat system.

# Requirements

* A relational database management system (RDBMS) (tested and developed using MySQL v8.0.16), with
a database and user for each of the docker containers ``elexis-server`` and ``bookstack`` has to be provided. 

* A file-system storage space

* A static IP address with a hostname in your domain for the server hosting this environment. This hostname has to be resolvable by all clients.

# Installation

Clone this repository to a directory on your server. Assert `docker-compose` is [installed](https://docs.docker.com/compose/install/).

## Pre-Start Configuration

Copy the file `.env.template` to `.env` and adapt the variables to your installation.

**IMPORTANT** Set a STRONG password for `ADMIN_PASS` and consider changing `ADMIN_USERNAME`. Obtaining these credentials allows administrator access to all services!

Be sure to have the values right - re-configuration is NOT supported!

Execute `docker run --rm configure ...`


See ssl for details on how to create your own certificate to use for this environment.
After acquiring your certificate be sure to adapt `EE_HOSTNAME` in `.env` and copy
the certificate files to `assets/web/ssl`.

Network configuration

## Initial start

```docker-compose up``` will instantiate all containers.

After starting one MUST change the Administrator password (by default set to `admin`) in LDAP! HOW?

## Accessing the services

* Bookstack with browser via https://yourhost/bookstack
* Rocketchat with browser via https://yourhost/chat
* LDAP with LDAPS client on ldaps://yourhost:636 



# Migrating existing data

Later version

# Technical details

## Docker containers

The following docker containers will be created:

- ```web``` SSL terminating reverse proxy and static resource provider. The only container exposing ports.
- ```elexis-server``` Elexis-Server instance
- ```ldap``` LDAP server for user management
- ```rocketchat``` A chat server
- ```bookstack``` A platform for organising and storing information (see https://www.bookstackapp.com/)
- hubot
- openid

## Mapping LDAP Groups to Elexis Roles

blabla


# TODO

* EE
  - Elexis Rollen zu LDAP Gruppen
  - ...
  - OpenID aus ES rauslösen
  - LDAP
    - IP based access restriction for readonly user (?)
  - MAIL Setup (?)
* Elexis UI
  - LDAP Anmeldung
  - Einbettung Rocketchat über Browser (user automatisch angemeldet)
  - Einbettung Bookstack über Browser (user automatisch)
* Themen
  - LDAP alleine für SSO nicht ausreichend
  - SSO zwischen Web-Applikation und Elexis?!
  - LDAP RO user should be only able to find DN not read attributes like contactId and stuff
* Rocketchat
  - Fallback passwort wenn ldap nicht funktioniert
  - LDAP wird nicht aktiviert
* Bookstack
  - Auto Setup Library
  - Further configuration
* Elexis-Server
  - OpenId an LDAP oder erste Version gar nicht
* Gedanken
  - EE schreibt über ES eehostname sowie public cert in db (Config#elexis-environment-host)
* myElexis
  - LetsEncrypt (for internal usage?)
  - HTTPS/SSL concept (DDNS)


# Libraries used

* https://github.com/baloise/rocket-chat-rest-client
* https://github.com/xo/usql/
* https://github.com/bitnami/bcrypt-cli


# Release 0.1 Checklist

* SSL Zertifikatsgenerierung
* Dynamic configuration
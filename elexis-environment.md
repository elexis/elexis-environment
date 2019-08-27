# Elexis-Environment v0.1

An integrated Elexis environment providing user management, elexis-server, a wiki and a chat system.

## Requirements

### External Requirements

A relational database management system (RDBMS) (tested and developed using MariaDB v8), with
a database and user for each of the docker containers ``es`` and ``bookstack``.

### Required parameters

- RDBMS data
- Domain-Name

# Installation

## Requirements preparation

Copy the file `env.template` to `.env` and set the values.

## Initial start

Clone this repository. Modify ```docker-compose.yml```

```docker-compose up```

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
- ```es``` Elexis-Server instance
- ```ldap``` LDAP server for user management
- ```rocketchat``` A chat server
- ```bookstack``` A platform for organising and storing information (see https://www.bookstackapp.com/)
- hubot
- openid

## Mapping LDAP Groups to Elexis Roles

blabla


# TODO

MAIL Setup

Offene Punkte EE

- Elexis Rollen zu LDAP Gruppen
- ...
- OpenID aus ES rauslösen
- LDAP
  - IP based access restriction for readonly user (?)

Offene Punkte Elexis

- LDAP Anmeldung
- Einbettung Rocketchat über Browser (user automatisch angemeldet)
- Einbettung WikiJs über Browser (user automatisch)

Offene Themen

- LDAP alleine für SSO nicht ausreichend
- SSO zwischen Web-Applikation und Elexis?!
- LDAP RO user should be only able to find DN not read attributes like contactId and stuff

Rocketchat

- Fallback passwort wenn ldap nicht funktioniert
- LDAP wird nicht aktiviert

Bookstack

- Auto Setup Library
- Further configuration

Gedanken

- EE schreibt über ES eehostname sowie public cert in db (Config#elexis-environment-host)
- 




# Libraries used

* https://github.com/baloise/rocket-chat-rest-client
* https://github.com/xo/usql/
* https://github.com/bitnami/bcrypt-cli
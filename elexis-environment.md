# Elexis-Environment v0.1

An integrated Elexis environment providing user management, elexis-server, a wiki and a chat system.

## Requirements

### External Requirements

A relational database management system (RDBMS) (tested and developed using MariaDB v8).

### Required parameters

- RDBMS data
- Domain-Name

# Installation

## Requirements preparation

### Setup the MongoDB

Initialize replica set ```rs.initiate( { _id: "rs0", members: [{ _id: 0, host: "localhost:27017" } ]} )```

## Initial start

Clone this repository. Modify ```docker-compose.yml``

```docker-compose up``

After starting one MUST change the Administrator password in LDAP! HOW?

# Migrating existing data

# Technical details

## Docker containers

The following docker containers will be created on ```docker-compose up```

- ```web``` SSL terminating reverse proxy and static resource provider. The only container exposing ports.
- ```es``` Elexis-Server instance
- ```ldap``` LDAP server for user management
- ```rocketchat```
- hubot
- openid

## Mapping LDAP Groups to Elexis Roles

blabla

# TODO

Offene Punkte EE

- Elexis Rollen zu LDAP Gruppen
- ...
- OpenID aus ES rauslösen
- LDAP
  - IP based access restriction for readonly user (?)

Offene Punke Elexis

- LDAP Anmeldung
- Einbettung Rocketchat über Browser (user automatisch angemeldet)
- Einbettung WikiJs über Browser (user automatisch)

Offene Themen

- LDAP alleine für SSO nicht ausreichend
- SSO zwischen Web-Applikation und Elexis?!
- LDAP RO user should be only able to find DN not read attributes like contactId and stuff


Gedanken

- EE schreibt über ES eehostname sowie public cert in db (Config#elexis-environment-host)
- 



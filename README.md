# Elexis-Environment v0.2 - WORK IN PROGRESS

An integrated Elexis environment providing elexis-server, ldap, single-sign-on, wiki and a chat system.

# Update v0.1 to v0.2

* Need to clean everything from v0.1 as the ldap structure has changed.
* Adapt .env file

# Caveat v0.2

* Rocketchat: The custom oauth keycloak gets already configured, but it needs to be manually added by admin logging in and adding custom oauth `Keycloak`. See https://github.com/RocketChat/docs/issues/790.

# Requirements

* A static IP address with a hostname in your domain for the server hosting this environment. This hostname has to be resolvable by all clients.

* A Linux system as host. Linux behaves different to Windows and OS X w.r.t. network handling. Only in a linux system the web container will see the real IP behind the HTTP requests.

* A relational database management system (RDBMS) (tested and developed using MySQL v8.0.16), with
a database and user for each of the docker containers ``elexis-server`` and ``bookstack``.

* A file-system storage space

# Installation

Clone this repository to a directory on your server. Assert `docker-compose` is [installed](https://docs.docker.com/compose/install/). Change into this directory for the following commands to work.

## Pre-Start Configuration

Copy the file `.env.template` to `.env` and adapt the variables to your installation.

**IMPORTANT** Set a STRONG password for `ADMIN_PASSWORD` and consider changing `ADMIN_USERNAME`. Obtaining these credentials allows administrator access to all services!

Be sure to have the values right - re-configuration is NOT supported!

Execute `./ee setup configure` to generate the files required for startup.

See [ssl configuration](doc/ssl.md) for details on how to create your own certificate to use for this environment.
After acquiring your certificate be sure to adapt `EE_HOSTNAME` in `.env` and copy
the certificate files to `assets/web/ssl`.

## Initial start

`./ee system cmd up -d --build` will instantiate all containers. `./ee system cmd ps` shows the current state of all containers.

Please see [notes](docs/notes.md) for FAQs and remarks.

# Operation

## Accessing the services

After initial startup, there will be two users available. The admin user with userid `ADMIN_USERNAME` and your set password, and a `demouser` with password `demouser`.

* Keycloak with browser via https://yourhost/keycloak
* Bookstack with browser via https://yourhost/bookstack
* Rocketchat with browser via https://yourhost/chat
* LDAP with LDAPS client on ldaps://yourhost:636 
* Elexis server via https://yourhost/fhir and https://yourhost/services respectively

# Technical details

## Docker containers

The following docker containers are created:

- ```web``` SSL terminating reverse proxy and static resource provider
- ```elexis-server``` Elexis-Server instance
- ```keycloak``` Single-Sign-On and User-Management solution
- ```ldap``` LDAP server
- ```rocketchat``` A [chat server](https://rocket.chat/)
- ```bookstack``` A platform for organising and storing information (see https://www.bookstackapp.com/)
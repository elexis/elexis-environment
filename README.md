# Elexis-Environment v0.1

An integrated Elexis environment providing elexis-server, ldap, wiki and a chat system.

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

**IMPORTANT** Set a STRONG password for `ADMIN_PASS` and consider changing `ADMIN_USERNAME`. Obtaining these credentials allows administrator access to all services!

Be sure to have the values right - re-configuration is NOT supported!

Execute `./ee setup reqtest` to generate the files required for startup.

See [ssl configuration](doc/ssl.md) for details on how to create your own certificate to use for this environment.
After acquiring your certificate be sure to adapt `EE_HOSTNAME` in `.env` and copy
the certificate files to `assets/web/ssl`.

## Initial start

`docker-compose up -d` will instantiate all containers. `docker-compose ps` shows the current state of all containers.

# Operation

## Accessing the services

After initial startup, there will be two users available. The admin user with userid `ADMIN_USERNAME` and your set password, and a `demouser` with password `demouser`.

* Bookstack with browser via https://yourhost/bookstack
* Rocketchat with browser via https://yourhost/chat
* LDAP with LDAPS client on ldaps://yourhost:636 
* Elexis server via https://yourhost/fhir and https://yourhost/services respectively

# Technical details

## Docker containers

The following docker containers are created:

- ```web``` SSL terminating reverse proxy and static resource provider
- ```elexis-server``` Elexis-Server instance
- ```ldap``` LDAP server
- ```rocketchat``` A [chat server](https://rocket.chat/)
- ```bookstack``` A platform for organising and storing information (see https://www.bookstackapp.com/)
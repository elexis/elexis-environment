# Elexis-Environment (EE) master

An integrated Elexis environment providing elexis-server, single-sign-on, wiki and a chat system.

## Requirements

* A static IP address with a hostname in your domain for the server hosting this environment. This hostname has to be resolvable by all clients.
* A Linux system as host. Linux behaves different to Windows and OS X with respect to network handling. Only in a linux system the web container will see the real IP behind the HTTP requests.
* A relational database management system (RDBMS) (tested and developed using MySQL v8.0.16), with
a database and user for each of the docker containers ``keycloak``, ``elexis-server`` and ``bookstack``.

## Installation

Clone this repository to a directory on your server. Assert `docker-compose` is [installed](https://docs.docker.com/compose/install/). Change into this directory for the following commands to work.

### Pre-Start Configuration

Copy the file `.env.template` to `.env` and adapt the variables to your installation.

**IMPORTANT** Set a STRONG password for `ADMIN_PASSWORD` and consider changing `ADMIN_USERNAME`. Obtaining these credentials allows administrator access to **all services**! In order to minimize the potential impact of a security bug in one of the services, you should also create a separate database user and strong password for each of the services.

Be sure to have the values right - re-configuration is NOT supported!

By default only the `elexis-server` service is active. To activate other services, set the respective variable to `true` in section 3 of `.env`.

Execute `./ee setup configure` to generate the files required for startup.

See [ssl configuration](docs/ssl.md) for details on how to create your own certificate to use for this environment.
After acquiring your certificate be sure to adapt `EE_HOSTNAME` in `.env` and copy
the certificate files to `assets/web/ssl`.

### Initial start

`./ee system cmd up -d --build` will instantiate all containers. `./ee system cmd ps` shows the current state of all containers. `./ee system cmd logs -f` will follow the logs.

Please see [notes](docs/notes.md) for FAQs and remarks.

### Accessing the services

After initial startup, there will be two users available. The admin user with userid `ADMIN_USERNAME` and your set password, and a `demouser` with password `demouser`.

* Keycloak with browser via https://yourhost/keycloak
* Bookstack with browser via https://yourhost/bookstack (if enabled)
* Rocketchat with browser via https://yourhost/chat (if enabled)
* Nextcloud with browser via https://yourhost/cloud (if enabled)
* Elexis server via https://yourhost/fhir and https://yourhost/services respectively (if enabled)
### Maintenance

Please see [maintenance](docs/maintenance.md).

## Development and Technical details

Please see [development](docs/development.md).

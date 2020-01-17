# Maintenance

## Backup

The following service data is stored (as docker volumes) within the elexis-environment:

* LDAP
  * Storage
  * Configuration
* Rocketchat
  * Database
  * File-Uploads
* Bookstack
  * File-Uploads
* Elexis-Server
  * Home

Execute `ee system backup` to back-up data into `site/backup`.

## Restore

TODO

## Updating an existing EE installation

In order to update an existing installation, perform the following steps:

1. Shut down the elexis-environment: `./ee system cmd stop`
2. Delete all existing containers: `./ee system cmd rm -f`
3. Fetch the current version from the respository :`git pull`
4. Update the configuration image:  `docker pull medevit/eenv-config`
5. Update the configuration: `./ee setup configure`
6. Pull current version images: `./ee system cmd pull --include-deps`
7. Bring .env up-to-date: `./ee setup reconfigure`
8. Start EE: `./ee system cmd up -d --build`
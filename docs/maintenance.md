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
3. (Optional) remove unused images (to free space): `docker image prune`
4. Fetch the current version from the respository :`git pull`
5. Update the configuration image:  `docker pull medevit/eenv-config`
6. Bring .env up-to-date: `./ee setup configure`
7. Pull current version images: `./ee system cmd pull --include-deps`
8. Start EE with new containers being built: `./ee system cmd up -d --build`

## Moving docker data to another filesystem

We will [move](https://linuxconfig.org/how-to-move-docker-s-default-var-lib-docker-to-another-directory-on-ubuntu-debian-linux) the docker default volumes directory to a new directory.

1. Shut down EE
2. Edit `/lib/systemd/system/docker.service` and modify `ExecStart` to add `--data-root /docker/volumes`
3. Stop docker `systemctl stop docker`
4. Ensure docker is stopped: Check via `ps aux | grep -i docker | grep -v grep` no output should follow
5. Reload docker configuration `systemctl daemon-reload`
6. `mv -v /var/lib/docker/* /docker/data/`
7. Start docker `systemctl start docker`
8. Check volumes are still there `docker volume ls`

### Initialize an empty harddisk

Steps to initialize a fresh harddisk with LVM and ext4

* Create a new single partition on the fresh harddisk and initialize it https://bencane.com/2011/12/19/creating-a-new-filesystem-with-fdisk-lvm-and-mkfs/
* `pvcreate /dev/sdb1`, `vgcreate ee-docker-data-vg /dev/sdb1`, `lvcreate -n ee-docker-data  -l100%FREE ee-docker-data-vg`, ` mkfs.ext4 /dev/mapper/ee--docker--data--vg-ee--docker--volumes`
* `mkdir -p /docker/data`, add to `/etc/fstab` 
* `chmod 701 /docker/data`
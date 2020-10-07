# Info

This Dockerfile overrieds the default nextcloud image to perform the following changes

* Add smb support for external locations
* Adapt entrypoint to add symbolic link required for php-fpm operation in subdir

## Building a newer image

1. Create a base image on the update base
2. Build the smbclient (see e.g. https://git.belmankraul.com/docker/nextcloud/src/branch/master/fpm-alpine/19/Dockerfile)
3. Copy the files to assets for inclusion
4. Update `ee-init.sh` 
5. Update `entrypoint.sh`(from https://github.com/nextcloud/docker) -> use original, but include 

```
# Elexis-Environment ############################
su -p www-data -s /bin/sh /ee-init.sh
##################################################

exec "$@"
```

before end

## TODO / Caveats

 Exception: Updates between multiple major versions and downgrades are unsupported.
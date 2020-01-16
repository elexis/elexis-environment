# Info

This Dockerfile overrieds the default nextcloud image to perform the following changes

* Add smb support for external locations
* Adapt entrypoint to add symbolic link required for php-fpm operation in subdir
# Development

## Docker containers

The following docker containers are created:

- ```web``` SSL terminating reverse proxy and static resource provider
- ```elexis-server``` Elexis-Server instance
- ```keycloak``` Single-Sign-On and User-Management solution
- ```ldap``` LDAP server
- ```rocketchat``` A [chat server](https://rocket.chat/)
- ```bookstack``` A platform for organising and storing information (see https://www.bookstackapp.com/)
- ```nextcloud``` A self-hosted file and productivity platform (see https://nextcloud.com)

## Theming

Theming can be applied to the different services within the following locations:

* WebPage (Nginx) - via volume mount in `docker/compose/assets/web/[internal|external]`
* Keycloak - via volume mount in  `docker/compose/assets/keycloak/themes/elexis-environment`
* Bookstack - via volume mount in `docker/compose/assets/bookstack`
* Rocketchat - via applied setting `Custom_Script_Logged_In`, see `rocketchat.sh`
* Nextcloud - 


## Elexis-Rap docker image

Adding the local site certificate to the Java Keystore

```
docker cp certificate.crt elexis-environment_elexis-rap_1:/certificate.crt
docker exec -u root -it elexis-environment_elexis-rap_1 /bin/bash
keytool -import -trustcacerts -keystore /usr/local/openjdk-8/lib/security/cacerts -storepass changeit -noprompt -alias mycert -file /certificate.crt
```
Pass the environment variable `DEVELOPMENT_MODE=true` to relax Jetty Keycloak filter rules

Restart the elexis-rap container after these changes
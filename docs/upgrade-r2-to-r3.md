Upgrading EE from R2 to R3

* S3 required (see [minio installation](minio/install.md))
    * In addition to an external RDBMS system, an S3 service is now required, it is to be configured with the `S3_*` variables
* Nextcloud [S3]
    * [MANUAL] Requires S3
    * [MANUAL] Remove keycloak nextcloud-saml if exists, is now openid (client id is cloud\/apps\/user)
    * [MANUAL] Users need to directly login in nextcloud for the first time, API provisioning is disabled
* Keycloak
    * Remove RealmRoles replaced by groups
    * Delete `nextcloud` client to get fresh initialization
    * Delete `elexis-rcp-openid` client to get fresh initialization
* Bookstack
    * Want to Import Medelexis Templates? See `./ee setup mysql_init_code` 
    * https://www.bookstackapp.com/docs/admin/ut8mb4-support/  `./ee cmd bookstack bookstack:db-utf8mb4`
* Elexis
    * TaskService remove all with runnableId `triggerTaskForEveryFile`
* Rocketchat
    * Service is removed and replaced by Matrix/Synapse
* Matrix/Synapse
    * Rquires S3
    * Adds co-located Postgres database
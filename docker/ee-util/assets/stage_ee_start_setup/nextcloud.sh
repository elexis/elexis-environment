#!/bin/bash
#
# Configure NextCloud for Elexis Operation
#
NC_BASEURL="https://$EE_HOSTNAME/cloud"
T="[NEXTCLOUD] "
echo "$T $(date)"

#
#
# Wait for login
#
#
LOOP_COUNT=0
while [[ "$(curl -s -o /dev/null -k -w ''%{http_code}'' -H "OCS-APIRequest: true" $NC_BASEURL/ocs/v2.php/cloud/capabilities)" != "200" ]]; do
    echo "$T Waiting for nextcloud  ..."
    sleep 5
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

#
#
# Basic configuration values
#
#
#echo -e "$T Assert basic configuration ..."
#java -jar /NextcloudSetter.jar -t -l NextcloudAdmin -p $ADMIN_PASSWORD -u $NC_BASEURL -v \
#    -s theming/name="${ORGANISATION_NAME//__/\ }" -s theming/url="$EE_HOSTNAME/cloud"

#
# OpenId configuration - https://github.com/pulsejet/nextcloud-oidc-login
# 
# TODO maybe move to ee-init.sh?
echo "$T Update oidc client secret ..."
NC_OPENID_CLIENT_SECRET=$(cat "/tmp/NC_OPENID_CLIENT_SECRET")
#MYSQL_STRING="INSERT INTO oc_user_oidc_providers(id, identifier, client_id, client_secret, discovery_endpoint, scope) \
#    VALUES ('1','Keycloak','nextcloud', '${NC_OPENID_CLIENT_SECRET}', 'https://${EE_HOSTNAME}/keycloak/auth/realms/ElexisEnvironment/.well-known/openid-configuration', 'openid email profile') \
#    ON DUPLICATE KEY UPDATE client_secret = '${NC_OPENID_CLIENT_SECRET}'"

MYSQL_STRING="UPDATE oc_user_oidc_providers SET client_secret='${NC_OPENID_CLIENT_SECRET}' WHERE (identifier = 'Keycloak')"
/usql mysql://${RDBMS_NEXTCLOUD_USERNAME}:${RDBMS_NEXTCLOUD_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_NEXTCLOUD_DATABASE} -c "$MYSQL_STRING"

#echo "$T Assert settings for oidc_provider nextcloud .."
#java -jar /NextcloudSetter.jar -t -l NextcloudAdmin -p $ADMIN_PASSWORD -u $NC_BASEURL -v \
#    -s user_oidc/id4me_enabled="0" \
#    -s user_oidc/provider-1-checkBearer="1" -s user_oidc/provider-1-mappingUid="preferred_username" \
#    -s user_oidc/provider-1-uniqueUid="0" -s user_oidc/provider-1-mappingEmail="email" \
#    -s user_oidc/provider-1-bearerProvisioning="1" -s user_oidc/provider-1-providerBasedId="0" \
#    -s user_oidc/provider-1-sendIdTokenHint="0"

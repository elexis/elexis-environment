#!/bin/bash
source keycloak_functions.sh
# Keycloak Nextcloud configuration script
T="$S (nextcloud)"

#
# NEXTCLOUD-OIDC
#
NC_OPENID_CLIENTID=$(getClientId nextcloud)
if [ -z $NC_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    NC_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=nextcloud -s enabled=false -i)
    echo "ok $NC_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$NC_OPENID_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_NEXTCLOUD \
    -s baseUrl=https://$EE_HOSTNAME/cloud/ -s secret=$X_EE_NEXTCLOUD_CLIENT_SECRET -f keycloak/nextcloud-openid.json
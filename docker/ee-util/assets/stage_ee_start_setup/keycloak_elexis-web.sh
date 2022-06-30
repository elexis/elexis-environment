#!/bin/bash
# Elexis-Web Keycloak Initialization Script
T="$S (elexis-web-api)"

ESWA_OPENID_CLIENTID=$(getClientId elexis-web-api)
if [ -z $ESWA_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ESWA_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-web-api -i)
    echo "ok $ESWA_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$ESWA_OPENID_CLIENTID -r ElexisEnvironment -s clientId=elexis-web-api -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_WEB_API_CLIENT_SECRET -s directAccessGrantsEnabled=false -s 'redirectUris=["/api/elexisweb/oidc/callback"]'
echo "$T update client enabled=$ENABLE_ELEXIS_WEB"
$KCADM update clients/$ESWA_OPENID_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_ELEXIS_WEB
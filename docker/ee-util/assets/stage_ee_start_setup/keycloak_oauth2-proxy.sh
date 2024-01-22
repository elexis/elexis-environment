#!/bin/bash
source keycloak_functions.sh
# oauth2-proxy client initialization
T="$S (oauth2-proxy)"

OAUTH2_PROXY_OPENID_CLIENTID=$(getClientId oauth2-proxy)
if [ -z $OAUTH2_PROXY_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    OAUTH2_PROXY_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=oauth2-proxy -i)
    echo "ok $OAUTH2_PROXY_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$OAUTH2_PROXY_OPENID_CLIENTID -r ElexisEnvironment -s clientAuthenticatorType=client-secret -s secret=$OAUTH2_PROXY_CLIENT_SECRET -s directAccessGrantsEnabled=false -s 'redirectUris=["/oauth2/callback"]'
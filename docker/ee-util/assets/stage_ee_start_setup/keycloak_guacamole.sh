#!/bin/bash
source keycloak_functions.sh
# Keycloak Guacamole configuration script
T="$S (guacamole)"

#
# GUACAMOLE-OIDC
#
GUCACAMOLE_OPENID_CLIENTID=$(getClientId guacamole)
if [ -z $GUCACAMOLE_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    GUCACAMOLE_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=guacamole -s enabled=false -i)
    echo "ok $GUCACAMOLE_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$GUCACAMOLE_OPENID_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_GUACAMOLE \
    -s baseUrl=https://$EE_HOSTNAME/guacamole/ -f keycloak/guacamole-openid.json
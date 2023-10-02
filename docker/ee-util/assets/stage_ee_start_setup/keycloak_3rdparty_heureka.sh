#!/bin/bash
source keycloak_functions.sh
#
# 3rdParty Healthinal Heureka Integration
# https://www.healthinal.com/de
#
T="$S (3rdparty-healthinal-heureka)"

THIRDP_HEALTHINAL_HEUREKA_CLIENT=$(getClientId healthinal-heureka)
if [ -z $3RDP_HEALTHINAL_HEUREKA_CLIENT ]; then
    echo -n "$T create client ... "
    THIRDP_HEALTHINAL_HEUREKA_CLIENT=$($KCADM create clients -r ElexisEnvironment -s clientId=healthinal-heureka -s enabled=false -i)
    echo "ok $THIRDP_HEALTHINAL_HEUREKA_CLIENT"
fi

X_EE_3RDP_HEALTHINAL_HEUREKA_CLIENT_SECRET=$(randomClientSecret)

echo "$T update client settings ... "
$KCADM update clients/$THIRDP_HEALTHINAL_HEUREKA_CLIENT -r ElexisEnvironment -s enabled=$ENABLE_3RDPARTY_HEUREKA \
     -s secret=$X_EE_3RDP_HEALTHINAL_HEUREKA_CLIENT_SECRET -f keycloak/healthinal-heureka-openid.json

# TODO
# Communicate configuration data to heureka client
# Limit client to heureka wg_services ip address (X-REAL-IP problem, routing between wireguard and web w/o nat)
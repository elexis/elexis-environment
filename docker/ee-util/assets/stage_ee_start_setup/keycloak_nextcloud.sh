#!/bin/bash
source keycloak_functions.sh
# Keycloak Nextcloud configuration script
T="$S (nextcloud)"

#
# NEXTCLOUD-OIDC
# does inherit realm roles (except user, medidcal-user, mandator)
# adds client role third-party
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

createOrUpdateClientRole $NC_OPENID_CLIENTID admin 'description=User with full administrator privileges'
createOrUpdateClientRole $NC_OPENID_CLIENTID third-party 'description=External user allowed to access specific folders'

# NEXTCLOUD: admin
# arzt -> RR medical-practitioner
# assistent -> RR medical-assistant
# bot -> RR bot
# mpa -> RR mpa
# mpk -> RR mpk
# third-party (integration für externe systeme, zugriff auf einzelne ordner)
# ict-administrator -> RR Admin Einstellung
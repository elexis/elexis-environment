#!/bin/bash
source keycloak_functions.sh
#
# 3rdParty Healthinal Heureka Integration
# https://www.healthinal.com/de
#
T="$S (3rdparty-healthinal-heureka)"

# Public Certificate for productive heureka registration endpoint, as supplied by Healthinal
HEALTHINAL_PRODREG_PUBKEY=sha256//Cf3eutsSUu4UUXkdQ6ca+EzRvhCdGlMoyOCfq++wyT4=

# PREPARE ELEXIS USER
echo "$T insert or update healthinal elexis user contact"
LASTUPDATE=$(date +%s)000
HEALTHINAL_CONTACT_ID="mngd1Healthinal100000000"
MYSQL_STRING="INSERT INTO KONTAKT(ID,LASTUPDATE,ISTORGANISATION,LAND,BEZEICHNUNG1,STRASSE,PLZ,ORT,TELEFON1,EMAIL,WEBSITE) VALUES ('${HEALTHINAL_CONTACT_ID}', '${LASTUPDATE}', '1', 'CH', 'Healthinal', 'Neue Jonastrasse 59', '8640', 'Rapperswil', '+41 55 511 04 60', 'info@healthinal.com', 'www.healthinal.com') ON DUPLICATE KEY UPDATE LASTUPDATE='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"
# TODO: assign a mandator

# CLIENT
THIRDP_HEALTHINAL_HEUREKA_CLIENT=$(getClientId healthinal-heureka)
if [ -z $THIRDP_HEALTHINAL_HEUREKA_CLIENT ]; then
    echo -n "$T create client ... "
    THIRDP_HEALTHINAL_HEUREKA_CLIENT=$($KCADM create clients -r ElexisEnvironment -s clientId=healthinal-heureka -s enabled=false -i)
    echo "ok $THIRDP_HEALTHINAL_HEUREKA_CLIENT"
fi

echo "$T update client settings ... "
X_EE_3RDP_HEALTHINAL_HEUREKA_CLIENT_SECRET=$(randomClientSecret)
$KCADM update clients/$THIRDP_HEALTHINAL_HEUREKA_CLIENT -r ElexisEnvironment -s enabled=$ENABLE_3RDPARTY_HEUREKA \
     -s secret=$X_EE_3RDP_HEALTHINAL_HEUREKA_CLIENT_SECRET -f keycloak/healthinal-heureka-openid.json

# USER
HEUREKABOT_USER_ID=$(getUserId heurekabot)
if [ -z $HEUREKABOT_USER_ID ]; then
    echo "$T create heurekabot user ... "
    $KCADM create users -r ElexisEnvironment -s username=heurekabot -s enabled=false
fi

echo "$T update heurekabot user ... "
RANDOM_USER_PASSWORD=$(randomClientSecret)
$KCADM set-password -r ElexisEnvironment --username heurekabot --new-password ${RANDOM_USER_PASSWORD}
$KCADM update users/$HEUREKABOT_USER_ID -r ElexisEnvironment -s enabled=${ENABLE_3RDPARTY_HEUREKA} -s "attributes.elexisContactId=${HEALTHINAL_CONTACT_ID}" -s email='info@healthinal.com' -s 'emailVerified=true'
$KCADM add-roles --uusername heurekabot --rolename bot -r ElexisEnvironment
$KCADM add-roles --uusername heurekabot --rolename medical-user -r ElexisEnvironment

# Inform Heureka about the changes
# TODO: What if Bridge is not active?
echo -n "$T Posting to https://10.101.0.11/ee-register ..."
WELL_KNOWN_URI="https://${EE_HOSTNAME}/.well-known/elexis-environment"
POST_BODY=$(jq -n --arg site_uuid ${X_EE_SITE_UUID} --arg client_secret ${X_EE_3RDP_HEALTHINAL_HEUREKA_CLIENT_SECRET} --arg elexis_password ${RANDOM_USER_PASSWORD}  --arg well_known_uri ${WELL_KNOWN_URI} -f keycloak_3rdparty_heureka_register.json.template)
curl -k --max-time 5 --pinnedpubkey ${HEALTHINAL_PRODREG_PUBKEY} --header 'Content-Type: application/json' --request POST --location 'https://10.101.0.11/ee-register' -d "${POST_BODY}"

# TODO: auto creation of bot user
# TODO: call /delete endpoint on deactivation
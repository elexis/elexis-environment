#!/bin/bash
# emr-adi-server Keycloak Initialization Script
T="$S (emr-adi-server)"

EMR_ADI_SERVER_OPENID_CLIENT=$(getClientId emr-adi-server | cut -d "," -f1)
if [ -z $EMR_ADI_SERVER_OPENID_CLIENT ]; then
    echo -n "$T create client ... "
    EMR_ADI_SERVER_OPENID_CLIENT=$($KCADM create clients -r ElexisEnvironment -s clientId=emr-adi-server -i)
    echo "ok $EMR_ADI_SERVER_OPENID_CLIENT"
fi

echo "$T update client settings and secret ... "
export EMR_ADI_SERVER_SECRET_UUID=$(uuidgen)
$KCADM update clients/$EMR_ADI_SERVER_OPENID_CLIENT -r ElexisEnvironment -s clientAuthenticatorType=client-secret -s secret=$EMR_ADI_SERVER_SECRET_UUID -s enabled=$ENABLE_EMR_ADI_SERVER  -f keycloak/emr-adi-server-openid.json

# elexisContactId attribute for EMR_ADI_SERVER_USER_NAME
MYSQL_STRING="SELECT KONTAKT_ID FROM USER_ WHERE ID ='Administrator'"
ADMIN_KONTAKT_ID=$(/usql mysql://${RDBMS_BOOKSTACK_USERNAME}:${RDBMS_BOOKSTACK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_BOOKSTACK_DATABASE} -c "$MYSQL_STRING" | sed -n 2p)

echo "$T asserting user for sync access ..."
export EMR_ADI_SERVER_USER_NAME=emr-adi-server
export EMR_ADI_SERVER_USER_PASSWORD=$(uuidgen)
$KCADM create users -r ElexisEnvironment -s username=$EMR_ADI_SERVER_USER_NAME -s "attributes.elexisContactId=${ADMIN_KONTAKT_ID}" -s enabled=true -i 
$KCADM add-roles --uusername $EMR_ADI_SERVER_USER_NAME --rolename elexis_user -r ElexisEnvironment
echo "$T update $EMR_ADI_SERVER_USER_NAME password ..."
$KCADM set-password -r ElexisEnvironment --username $EMR_ADI_SERVER_USER_NAME --new-password $EMR_ADI_SERVER_USER_PASSWORD

# to be consumed in emr-adi-server.sh
envsubst <emr-adi-server_synctemplate.json >emr-adi-server.json
export -n EMR_ADI_SERVER_USER_PASSWORD

# TODO user has to exist in elexis!!
# i.e.s.c.s.f.ContextSettingFilter - User [emr-adi-server] not loadable in local database. Denying request.
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
EMR_ADI_SERVER_SECRET_UUID=$(uuidgen)
$KCADM update clients/$EMR_ADI_SERVER_OPENID_CLIENT -r ElexisEnvironment -s clientAuthenticatorType=client-secret -s secret=$EMR_ADI_SERVER_SECRET_UUID -s enabled=$ENABLE_EMR_ADI_SERVER  -f keycloak/elexis-rcp-openid.json

EMR_ADI_SERVER_USER_NAME=emr-adi-server
EMR_ADI_SERVER_USER_PASSWORD=$(uuidgen)
$KCADM create users -r ElexisEnvironment -s username=$EMR_ADI_SERVER_USER_NAME -i
$KCADM set-password -r ElexisEnvironment --username $EMR_ADI_SERVER_USER_NAME --password $EMR_ADI_SERVER_USER_PASSWORD

# to be consumed in emr-adi-server.sh
export EMR_ADI_SERVER_SECRET_UUID
export EMR_ADI_SERVER_USER_NAME
export EMR_ADI_SERVER_USER_PASSWORD
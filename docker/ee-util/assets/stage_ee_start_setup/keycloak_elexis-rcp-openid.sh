#!/bin/bash
# Elexis-RCP Keycloak configuration script
T="$S (elexis-rcp-openid)"

ERCP_OPENID_CLIENTID=$(getClientId elexis-rcp-openid)
if [ -z $ERCP_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ERCP_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-rcp-openid -i)
    echo "ok $ERCP_OPENID_CLIENTID"
fi

echo "$T update client settings and secret ... "
RCP_SECRET_UUID=$(uuidgen)
echo "$T secret: $RCP_SECRET_UUID"
$KCADM update clients/$ERCP_OPENID_CLIENTID -r ElexisEnvironment -s clientAuthenticatorType=client-secret -s secret=$RCP_SECRET_UUID -s enabled=$ENABLE_ELEXIS_RCP  -f keycloak/elexis-rcp-openid.json
# $KCADM create clients/$ERCP_OPENID_CLIENTID/roles -r ElexisEnvironment -s name=user -s 'description=Application user, required to log-in'
# $KCADM create clients/$ERCP_OPENID_CLIENTID/roles -r ElexisEnvironment -s name=doctor
# $KCADM create clients/$ERCP_OPENID_CLIENTID/roles -r ElexisEnvironment -s name=executive_doctor

echo "$T insert clientId/secret into elexis database .."
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RCP_OPENID_SECRET', '${RCP_SECRET_UUID}') ON DUPLICATE KEY UPDATE wert = '${RCP_SECRET_UUID}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

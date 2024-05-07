#!/bin/bash
source keycloak/keycloak_functions.sh
echo "$T $(date)"

#
# Wait for Login
#
RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD)
STATUS="$?"
LOOP_COUNT=0
while [ $STATUS != 0 ]; do
    echo "$T Waiting for keycloak [$STATUS] ($RESPONSE) ..."
    sleep 10
    RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD)
    STATUS="$?"
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

#
# Master Realm Theme setting
# TODO: move to repair step
#
echo "$T Master realm theme settings ..."
$KCADM update realms/master -s loginTheme=keycloak -s accountTheme=keycloak -s adminTheme=keycloak -s emailTheme=keycloak

#
# Initialization via keycloak-config-cli
# https://github.com/adorsys/keycloak-config-cli
#
TEMPLATE_FILE=keycloak/templates/elexis-environment.json
RESULT_FILE=keycloak/result-elexis-environment.json
cp $TEMPLATE_FILE $RESULT_FILE

# rocketchat preparation
openssl req -nodes -new -x509 -days 730 -keyout /rocketchat-saml-private.key -out /rocketchat-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Rocketchat"
export RC_SAML_PUBLIC_CERT=$(cat /rocketchat-saml-public.cert | sed '1,1d' | sed '$ d')

#
# Generate ElexisEnvironment.json input file for keycloak-config-cli
#
echo "$T Determine ElexisEnvironment realm settings ... "
for client_file in keycloak/templates/clients/*.json; do
    # we provide a client secret for every client
    BASENAME=$(basename $client_file | tr a-z A-Z)
    export SECRET_${BASENAME//[\.-]/_}="$(randomClientSecret)"
    echo "$T client $client_file (adding env SECRET_${BASENAME//[\.-]/_})"
    jq --argjson client "$(jq -c '.' "$client_file")" '.clients += [$client]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for client_roles_file in keycloak/templates/client-roles/*.json; do
    echo "$T client roles $client_roles_file "
    jq --argjson clientroles "$(jq -c '.' "$client_roles_file")" '.roles.client += $clientroles' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for flows_file in keycloak/templates/flows/*.json; do
    echo "$T flow $flows_file "
    jq --argjson authflow "$(jq -c '.' "$flows_file")" '.authenticationFlows += [$authflow]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

#
# Execute keycloak-config-cli
#
echo "$T Apply ElexisEnvironment realm settings ..."
java -jar $KC_CONFIG_CLI_JAR \
	--keycloak.url=https://${EE_HOSTNAME}/keycloak/auth \
	--keycloak.ssl-verify=true \
   	--keycloak.user=KeycloakAdmin \
  	--keycloak.password=${ADMIN_PASSWORD} \
 	--import.validate=true \
    --import.var-substitution.enabled=true \
    --import.files.locations=$RESULT_FILE

#
# Provide Elexis-Environment realm keys to other services
# used by Elexis self and rocketchat
#
echo "$T Output realm keys to /ElexisEnvironmentRealmKeys.json ..."
$KCADM get keys -r ElexisEnvironment >/ElexisEnvironmentRealmKeys.json
echo "$T Add realm public key to DB ${RDBMS_ELEXIS_DATABASE}"
REALM_PUBLIC_KEY=$(jq '.keys[] | select(.algorithm == "RS256") | select(.status == "ACTIVE") | .publicKey' -r /ElexisEnvironmentRealmKeys.json)
LASTUPDATE=$(date +%s)000


if [ $ENABLE_ELEXIS_SERVER == "true" ] || [ $ENABLE_ELEXIS_RCP == "true" ]; then
    echo "$T Put realm public key into elexis database .."
    MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_KC_REALM_PUBLIC_KEY', '${REALM_PUBLIC_KEY}') ON DUPLICATE KEY UPDATE wert = '${REALM_PUBLIC_KEY}', lastupdate='${LASTUPDATE}'"
    /usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

    echo "$T insert clientId/secret into elexis database .."
    LASTUPDATE=$(date +%s)000
    MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RCP_OPENID_SECRET', '${SECRET_ELEXIS_RCP_OPENID_JSON}') ON DUPLICATE KEY UPDATE wert = '${SECRET_ELEXIS_RCP_OPENID_JSON}', lastupdate='${LASTUPDATE}'"
    /usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"
fi

if [ $ENABLE_3RDPARTY_HEUREKA == "true" ]; then
    source keycloak/keycloak_3rdparty_heureka.sh
fi
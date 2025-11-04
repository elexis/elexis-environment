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

#
# Generate ElexisEnvironment.json input file for keycloak-config-cli
#
EE_HOSTNAME_SHORT=${EE_HOSTNAME//.myelexis.ch/}
export EE_HOSTNAME_SHORT

echo "$T Determine ElexisEnvironment realm settings ... "
for client_file in keycloak/templates/clients/*.json; do
    echo "$T client $client_file"
    jq --argjson client "$(jq -c '.' "$client_file")" '.clients += [$client]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for client_roles_file in keycloak/templates/client-roles/*.json; do
    echo "$T client roles $client_roles_file "
    jq --argjson clientroles "$(jq -c '.' "$client_roles_file")" '.roles.client += $clientroles' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for client_scope_mappings_files in keycloak/templates/client-scope-mappings/*.json; do
    echo "$T client scope mappings $client_scope_mappings_files "
    jq --argjson clientScopeMappings "$(jq -c '.' "$client_scope_mappings_files")" '.clientScopeMappings += $clientScopeMappings' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for scope_mappings_files in keycloak/templates/scope-mappings/*.json; do
    echo "$T scope mappings $scope_mappings_files "
    jq --argjson scopeMappings "$(jq -c '.' "$scope_mappings_files")" '.scopeMappings += [$scopeMappings]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

for flows_file in keycloak/templates/flows/*.json; do
    echo "$T flow $flows_file "
    jq --argjson authflow "$(jq -c '.' "$flows_file")" '.authenticationFlows += [$authflow]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
done

# Medelexis IdP basic configuration
jq --argjson medelexisidp "$(jq -c '.' "keycloak/templates/identity-provider/keycloak-medelexis-idp.json")" '.identityProviders += [$medelexisidp]' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"
jq --argjson medelexisidpm "$(jq -c '.' "keycloak/templates/identity-provider/keycloak-medelexis-idpm.json")" '.identityProviderMappers += $medelexisidpm' "$RESULT_FILE" > temp.json && mv temp.json "$RESULT_FILE"

#
# Execute keycloak-config-cli
#
echo "$T Apply ElexisEnvironment realm settings ..."
java -jar $KC_CONFIG_CLI_JAR \
	--keycloak.url=http://keycloak:8080/keycloak/auth \
	--keycloak.ssl-verify=false \
   	--keycloak.user=KeycloakAdmin \
  	--keycloak.password=${ADMIN_PASSWORD} \
 	--import.validate=true \
    --logging.level.keycloak-config-cli=debug \
    --import.var-substitution.enabled=true \
    --import.managed.group=no-delete \
    --import.files.locations=$RESULT_FILE

#
# Provide Elexis-Environment realm keys to other services
# used by Elexis self
#
echo "$T Output realm keys to /ElexisEnvironmentRealmKeys.json ..."
$KCADM get keys -r ElexisEnvironment >/ElexisEnvironmentRealmKeys.json
echo "$T Add realm public key to DB ${RDBMS_ELEXIS_DATABASE}"
REALM_PUBLIC_KEY=$(jq '.keys[] | select(.algorithm == "RS256") | select(.status == "ACTIVE") | select(.use == "SIG") | .publicKey' -r /ElexisEnvironmentRealmKeys.json)
LASTUPDATE=$(date +%s)000


if [ $ENABLE_ELEXIS_SERVER == "true" ] || [ $ENABLE_ELEXIS_RCP == "true" ]; then
    USQL_PARAM="${RDBMS_ELEXIS_TYPE-$RDBMS_TYPE}://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_ELEXIS_HOST-$RDBMS_HOST}:${RDBMS_ELEXIS_PORT-$RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE}"

    echo "$T Put realm public key into elexis database .."
    SQL_STRING="DELETE FROM CONFIG WHERE param = 'EE_KC_REALM_PUBLIC_KEY'; INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_KC_REALM_PUBLIC_KEY', '${REALM_PUBLIC_KEY}');"
    /usql $USQL_PARAM -c "$SQL_STRING"

    echo "$T insert clientId/secret into elexis database .."
    LASTUPDATE=$(date +%s)000
    SQL_STRING="DELETE FROM CONFIG WHERE param = 'EE_RCP_OPENID_SECRET'; INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RCP_OPENID_SECRET', '${ELEXIS_RCP_CLIENT_SECRET}');"
    /usql $USQL_PARAM -c "$SQL_STRING"
fi

if [ $ENABLE_3RDPARTY_HEUREKA == "true" ]; then
    source keycloak/keycloak_3rdparty_heureka.sh
fi
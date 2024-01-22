#!/bin/bash
source keycloak_functions.sh
echo "$T $(date)"

#
# Wait for Login
#
echo -n "$T"
RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD)
STATUS="$?"
LOOP_COUNT=0
while [ $STATUS != 0 ]; do
    echo "$T Waiting for keycloak [$STATUS] ($RESPONSE) ..."
    sleep 15
    RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD)
    STATUS="$?"
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

#
# Assert Elexis-Environment Realm exists
#
REALMID=$($KCADM get realms/ElexisEnvironment --fields id -c --format csv --noquotes)
if [ -z $REALMID ]; then
    echo -n "$T create ElexisEnvironment realm ... "
    $KCADM create realms -s realm=ElexisEnvironment -s enabled=true -s displayName=Elexis-Environment -s sslRequired=none -i
    REALMID=$($KCADM get realms/ElexisEnvironment --fields id -c --format csv --noquotes)
    echo "ok $REALMID"
fi

#
# Update ElexisEnvironment Realm configuration
#
echo "$T Basic ElexisEnvironment realm settings ..."
$KCADM update realms/ElexisEnvironment -s userManagedAccessAllowed=true -s bruteForceProtected=true \
    -s loginTheme=elexis-environment -s accountTheme=elexis-environment -s adminTheme=keycloak -s emailTheme=elexis-environment \
    -s smtpServer.host=$EE_HOST_INTERNAL_IP  -s smtpServer.from=keycloak@$EE_HOSTNAME -s smtpServer.auth=false -s smtpServer.ssl=false \
    -s registrationAllowed=false -s internationalizationEnabled=true -s defaultLocale=de \
    -s ssoSessionIdleTimeout=7200 -s ssoSessionMaxLifespan=86400

#
# Add realm roles according to Elexis defined roles
#
createOrUpdateRealmRole user 'description=Menschlicher Benutzer von Elexis, kann sich in Elexis RCP anmelden'
createOrUpdateRealmRole bot 'description=Bot Benutzer, keine reale Person, kann sich nicht in Elexis RCP anmelden'
createOrUpdateRealmRole medical-user 'description=Benutzer kann auf medizinische Daten zugreifen'
createOrUpdateRealmRole medical-practitioner 'description=Benutzer ist Dr. med. und agiert als solcher'
createOrUpdateRealmRole medical-assistant 'description=Benutzer ist medizinischer Assistent und agiert als solcher'
createOrUpdateRealmRole mandator 'description=Benutzer in dessen Namen Leistungen verrechnet und Rechnungen gestellt werden können'
createOrUpdateRealmRole mpa 'description=Benutzer ist praktischer Assistent, ohne Zugriff auf medizinische Daten'
createOrUpdateRealmRole mpk 'description=Benutzer ist ??'
createOrUpdateRealmRole ict-administrator 'description=Benutzer ist für Administration der Praxis zuständig. Kein Zugang auf medizinische Daten'
createOrUpdateRealmRole poweruser 'description=Benutzer ist ??'

#
# Master Realm Theme setting
#
echo "$T Master realm theme settings ..."
$KCADM update realms/master -s loginTheme=keycloak -s accountTheme=keycloak -s adminTheme=keycloak -s emailTheme=keycloak

#
# Provide Elexis-Environment realm keys to other services
#
echo "$T Output realm keys to /ElexisEnvironmentRealmKeys.json ..."
$KCADM get keys -r ElexisEnvironment >/ElexisEnvironmentRealmKeys.json
echo "$T Add realm public key to DB ${RDBMS_ELEXIS_DATABASE}"
REALM_PUBLIC_KEY=$(jq '.keys[] | select(.algorithm == "RS256") | select(.status == "ACTIVE") | .publicKey' -r /ElexisEnvironmentRealmKeys.json)
LASTUPDATE=$(date +%s)000
# Put realm public key into elexis database
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_KC_REALM_PUBLIC_KEY', '${REALM_PUBLIC_KEY}') ON DUPLICATE KEY UPDATE wert = '${REALM_PUBLIC_KEY}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

#
# oauth2-proxy
#
./keycloak_oauth2-proxy.sh

echo "$T Parallel keycloak configuration scripts ...."

./keycloak_browserflow.sh &
P1=$!

./keycloak_rocketchat.sh &
P2=$!

./keycloak_bookstack.sh &
P3=$!

./keycloak_nextcloud.sh &
P4=$!

./keycloak_elexis-server.sh &
P5=$!

./keycloak_elexis-web.sh &
P6=$!

./keycloak_solr.sh &
P7=$!

./keycloak_guacamole.sh &
P8=$!

./keycloak_3rdparty_heureka.sh &
P9=$!


wait $P1 $P2 $P3 $P4 $P5 $P6 $P7 $P8 $P9

# ELEXIS-RCP-OPENID
# references solr client in mapper
source keycloak_elexis-rcp-openid.sh
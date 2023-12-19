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
# Assert Browser Conditional Otp flow exists and is set as default
#
T="$S (browser dynamic otp flow)"
BROWSER_COND_OTP_FLOW_ID=$($KCADM get authentication/flows -r ElexisEnvironment --format csv --fields id,alias,description --noquotes | grep ,EE\ browser | cut -d "," -f1)
if [ ! -z $BROWSER_COND_OTP_FLOW_ID ]; then
    echo "$T remove existing ... "
    $KCADM update realms/ElexisEnvironment -s browserFlow='browser' # otherwise removal fails
    $KCADM delete authentication/flows/$BROWSER_COND_OTP_FLOW_ID -r ElexisEnvironment
fi

echo "$T create flow ... "
BROWSER_COND_OTP_FLOW_ID=$($KCADM create authentication/flows -r ElexisEnvironment -s alias='EE browser dynamic otp' -s providerId=basic-flow -s description='browser based authentication with conditional otp' -s topLevel=true -i)
EXECUTION_ID=$($KCADM create authentication/flows/EE%20browser%20dynamic%20otp/executions/execution -r ElexisEnvironment -s provider=auth-cookie -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_cookie.json
echo "$T create [EE Browser Dynamic Otp Forms] sub flow ..."
SUB_FLOW_ID=$($KCADM create authentication/flows/EE%20browser%20dynamic%20otp/executions/flow -r ElexisEnvironment -s alias='EE Browser Dynamic Otp Forms' -s type='basic-flow' -i)
EXECUTION_ID=$($KCADM get authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment --format csv --noquotes | grep $SUB_FLOW_ID | cut -d "," -f1)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -s flowId=$SUB_FLOW_ID -f keycloak/browser_cond_otp_flow_subflow.json
EXECUTION_ID=$($KCADM create authentication/flows/EE%20Browser%20Dynamic%20Otp%20Forms/executions/execution -r ElexisEnvironment -s provider=auth-username-password-form -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_subflow_userpass.json
EXECUTION_ID=$($KCADM create authentication/flows/EE%20Browser%20Dynamic%20Otp%20Forms/executions/execution -r ElexisEnvironment -s provider=auth-conditional-otp-form -i)
$KCADM update authentication/flows/EE%20browser%20dynamic%20otp/executions -r ElexisEnvironment -s id=$EXECUTION_ID -f keycloak/browser_cond_otp_flow_subflow_condotp.json
$KCADM create authentication/executions/$EXECUTION_ID/config -r ElexisEnvironment -f keycloak/browser_cond_otp_flow_subflow_condotp_config.json
echo "$T setting as default browser flow ..."
$KCADM update realms/ElexisEnvironment -s browserFlow='EE browser dynamic otp'

#
# ROCKETCHAT-SAML
#
T="$S (rocketchat-saml)"
RC_SAML_CLIENTID=$(getClientId rocketchat-saml\$)
if [ -z $RC_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    RC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=rocketchat-saml -i)
    echo "ok $RC_SAML_CLIENTID"
fi

echo "$T update client settings ... "
openssl req -nodes -new -x509 -days 730 -keyout /rocketchat-saml-private.key -out /rocketchat-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Rocketchat"
RC_SAML_PUBLIC_CERT=$(cat /rocketchat-saml-public.cert | sed '1,1d' | sed '$ d')
$KCADM update clients/$RC_SAML_CLIENTID -r ElexisEnvironment -s clientId=rocketchat-saml -s 'attributes."saml.signing.certificate"='"$RC_SAML_PUBLIC_CERT" -s adminUrl=https://$EE_HOSTNAME/chat/_saml_metadata/rocketchat-saml -f keycloak/rocketchat-saml.json
# see https://rocket.chat/docs/administrator-guides/permissions/ for full list, only using relevant roles
createOrUpdateClientRole $RC_SAML_CLIENTID user 'description=Normal user rights. Most users receive this role when registering.'
createOrUpdateClientRole $RC_SAML_CLIENTID admin 'description=Have access to all settings and administrator tools.'
createOrUpdateClientRole $RC_SAML_CLIENTID livechat-agent 'description=Agents of livechat. They can answer to livechat requests.'
createOrUpdateClientRole $RC_SAML_CLIENTID livechat-manager 'description=Manager of livechat, they can manage agents and guest.'
echo "$T update client enabled=$ENABLE_ROCKETCHAT"
$KCADM update clients/$RC_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_ROCKETCHAT

#
# BOOKSTACK-SAML
#
T="$S (bookstack-saml)"
BS_SAML_CLIENTID=$(getClientId bookstack\/saml2\/metadata)
if [ -z $BS_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    BS_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/bookstack/saml2/metadata -i)
    echo "ok $BS_SAML_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$BS_SAML_CLIENTID -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/bookstack/saml2/metadata -f keycloak/bookstack-saml.json
createSamlClientMapper $BS_SAML_CLIENTID firstName saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID lastName saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID username saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID email saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID role saml-role-list-mapper keycloak/bookstack-saml-mapper-role.json
createOrUpdateClientRole $BS_SAML_CLIENTID admin 'description=Administrator of the whole application'
createOrUpdateClientRole $BS_SAML_CLIENTID editor 'description=User can edit Books, Chapters & Pages'
createOrUpdateClientRole $BS_SAML_CLIENTID viewer 'description=User can view books & their content behind authentication'
createOrUpdateClientRole $BS_SAML_CLIENTID public 'description=The role given to public visitors if allowed'
echo "$T update client enabled=$ENABLE_BOOKSTACK"
$KCADM update clients/$BS_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_BOOKSTACK

#
# NEXTCLOUD-SAML
#
T="$S (nexctcloud-saml)"
NC_SAML_CLIENTID=$(getClientId cloud\/apps\/user)
if [ -z $NC_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    NC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata  -i)
    echo "ok $NC_SAML_CLIENTID"
fi

echo "$T update client settings ... "
openssl req -nodes -new -x509 -keyout /nextcloud-saml-private.key -out /nextcloud-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Nextcloud"
NC_SAML_PUBLIC_CERT=$(cat /nextcloud-saml-public.cert | sed '1,1d' | sed '$ d')
$KCADM update clients/$NC_SAML_CLIENTID -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata -s 'attributes."saml.signing.certificate"='"$NC_SAML_PUBLIC_CERT" -f keycloak/nextcloud-saml.json
echo "$T update client enabled=$ENABLE_NEXTCLOUD"
$KCADM update clients/$NC_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_NEXTCLOUD
createSamlClientMapper $NC_SAML_CLIENTID username saml-user-property-mapper
createSamlClientMapper $NC_SAML_CLIENTID email saml-user-property-mapper
createSamlClientMapper $NC_SAML_CLIENTID nextcloudquota saml-user-property-mapper
# No further support as of Keycloak 18, find replacement in due time
# createSamlClientMapper $NC_SAML_CLIENTID cn saml-javascript-mapper keycloak/nextcloud-saml-mapper-cn.json

#
# ELEXIS-SERVER.FHIR-API (Bearer Only)
#
T="$S (elexis-server.fhir-api)"
ES_FHIR_OPENID_CLIENTID=$(getClientId elexis-server.fhir-api | cut -d "," -f1)
if [ -z $ES_FHIR_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ES_FHIR_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-server.fhir-api -i)
    echo "ok $ES_FHIR_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$ES_FHIR_OPENID_CLIENTID -r ElexisEnvironment -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_SERVER_CLIENT_SECRET -s bearerOnly=true

#
# ELEXIS-SERVER.JAXRS-API (Bearer Only)
#
T="$S (elexis-server.jaxrs-api)"
ES_JAXRS_OPENID_CLIENTID=$(getClientId elexis-server.jaxrs-api | cut -d "," -f1)
if [ -z $ES_JAXRS_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ES_JAXRS_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-server.jaxrs-api -i)
    echo "ok $ES_JAXRS_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$ES_JAXRS_OPENID_CLIENTID -r ElexisEnvironment -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_SERVER_CLIENT_SECRET -s bearerOnly=true

source keycloak_elexis-web.sh

source keycloak_solr.sh

source keycloak_3rdparty_heureka.sh

# ELEXIS-RCP-OPENID
# references solr client in mapper
source keycloak_elexis-rcp-openid.sh
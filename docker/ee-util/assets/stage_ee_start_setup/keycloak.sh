#!/bin/bash
V=7.0.1
KCADM=/$V/kcadm.sh
T="[KEYCLOAK] "
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
# Basic Realm configuration options
#
echo "$T Basic ElexisEnvironment realm settings ..."
$KCADM update realms/ElexisEnvironment -s userManagedAccessAllowed=true -s bruteForceProtected=true -s loginTheme=elexis

#
# Provide Elexis-Environment realm keys to other services
#
echo "$T Output realm keys to /ElexisEnvironmentRealmKeys.json ..."
$KCADM get keys -r ElexisEnvironment >/ElexisEnvironmentRealmKeys.json

#
# Assert Browser Conditional Otp flow exists and is set as default
#
BROWSER_COND_OTP_FLOW_ID=$($KCADM get authentication/flows -r ElexisEnvironment --format csv --fields id,alias,description --noquotes | grep ,EE\ browser | cut -d "," -f1)
if [ ! -z $BROWSER_COND_OTP_FLOW_ID ]; then
    echo "$T remove existing browser conditional otp flow ... "
    $KCADM update realms/ElexisEnvironment -s browserFlow='browser' # otherwise removal fails
    $KCADM delete authentication/flows/$BROWSER_COND_OTP_FLOW_ID -r ElexisEnvironment
fi

echo "$T create [EE browser dynamic otp] flow ... "
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
echo "$T setting [EE browser dynamic otp] flow as default browser flow ..."
$KCADM update realms/ElexisEnvironment -s browserFlow='EE browser dynamic otp'

#
# Assert ldap user storage provider
#
LDAP_USP_ID=$($KCADM get components -r ElexisEnvironment --format csv --fields providerId,id,providerType --noquotes | grep org.keycloak.storage.UserStorageProvider\$ | grep ^ldap | cut -d "," -f2)
if [ -z $LDAP_USP_ID ]; then
    echo -n "$T create ldap storage provider ... "
    LDAP_USP_ID=$($KCADM create components -r ElexisEnvironment -s name=ldap -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s parentId=$REALMID \
        -s 'config.bindCredential=["'$ADMIN_PASSWORD'"]' -s 'config.bindDn=["'cn=admin,$ORGANISATION_BASE_DN'"]' -s 'config.usersDn=["'ou=people,$ORGANISATION_BASE_DN'"]' -f keycloak/ldap.json -i)
    echo "ok $LDAP_USP_ID"

    echo -n "$T create group-ldap-mapper ... "
    LDAP_UPS_GM_ID=$($KCADM create components -r ElexisEnvironment -s name=ldap_groups -s providerId=group-ldap-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper \
        -s parentId=$LDAP_USP_ID -s 'config."groups.dn"=["'ou=groups,$ORGANISATION_BASE_DN'"]' -f keycloak/ldap_groups.json -i)
    echo "ok $LDAP_UPS_GM_ID"

    echo -n "$T create elexisContactId user-attribute-ldap-mapper ..."
    LDAP_UPS_UALM_EC_ID=$($KCADM create components -r ElexisEnvironment -s name=elexisContactId -s providerId=user-attribute-ldap-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper \
        -s parentId=$LDAP_USP_ID -s 'config."ldap.attribute"=["elexisContactId"]' -s 'config."user.model.attribute"=["elexisContactId"]' -i)
    echo "ok $LDAP_UPS_UALM_EC_ID"
fi

echo "$T trigger synchronization of all users ... "
$KCADM create -r ElexisEnvironment user-storage/$LDAP_USP_ID/sync?action=triggerFullSync

#
# ROCKETCHAT-SAML
# Re-create on every startup
#
RC_SAML_CLIENTID=$($KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep rocketchat-saml\$ | cut -d "," -f1)
if [ ! -z $RC_SAML_CLIENTID ]; then
    echo -n "$T remove existing rocketchat saml-client ... "
    $KCADM delete clients/$RC_SAML_CLIENTID -r ElexisEnvironment
fi

if [[ $ENABLE_ROCKETCHAT == true ]]; then
    echo -n "$T assert rocketchat saml-client ... "
    openssl req -nodes -new -x509 -keyout /rocketchat-saml-private.key -out /rocketchat-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Rocketchat"
    RC_SAML_PUBLIC_CERT=$(cat /rocketchat-saml-public.cert | sed '1,1d' | sed '$ d')

    RC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=rocketchat-saml -s 'attributes."saml.signing.certificate"='"$RC_SAML_PUBLIC_CERT" -s adminUrl=https://$EE_HOSTNAME/chat/_saml_metadata/rocketchat-saml -s enabled=true -f keycloak/rocketchat-saml.json -i)
    echo "ok $RC_SAML_CLIENTID"

    # see https://rocket.chat/docs/administrator-guides/permissions/ for full list, only using relevant roles
    $KCADM create clients/$RC_SAML_CLIENTID/roles -r ElexisEnvironment -s name=user -s 'description=Normal user rights. Most users receive this role when registering.'
    $KCADM create clients/$RC_SAML_CLIENTID/roles -r ElexisEnvironment -s name=admin -s 'description=Have access to all settings and administrator tools.'
    $KCADM create clients/$RC_SAML_CLIENTID/roles -r ElexisEnvironment -s name=livechat-agent -s 'description=Agents of livechat. They can answer to livechat requests.'
    $KCADM create clients/$RC_SAML_CLIENTID/roles -r ElexisEnvironment -s name=livechat-manager -s 'description=Manager of livechat, they can manage agents and guest.'
fi

#
# BOOKSTACK-SAML
# Re-create on every startup
#
BS_SAML_CLIENTID=$($KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep bookstack\/saml2\/metadata | cut -d "," -f1)
if [ ! -z $BS_SAML_CLIENTID ]; then
    echo -n "$T remove existing bookstack-saml client... "
    $KCADM delete clients/$BS_SAML_CLIENTID -r ElexisEnvironment
fi

if [[ $ENABLE_BOOKSTACK == true ]]; then
    echo -n "$T assert bookstack-saml client ... "

    BS_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/bookstack/saml2/metadata -s enabled=true -f keycloak/bookstack-saml.json -i)
    echo "ok $BS_SAML_CLIENTID"

    $KCADM create clients/$BS_SAML_CLIENTID/roles -r ElexisEnvironment -s name=admin -s 'description=Administrator of the whole application'
    $KCADM create clients/$BS_SAML_CLIENTID/roles -r ElexisEnvironment -s name=editor -s 'description=User can edit Books, Chapters & Pages'
    $KCADM create clients/$BS_SAML_CLIENTID/roles -r ElexisEnvironment -s name=viewer -s 'description=User can view books & their content behind authentication'
    $KCADM create clients/$BS_SAML_CLIENTID/roles -r ElexisEnvironment -s name=public -s 'description=The role given to public visitors if allowed'
fi

#
# NEXTCLOUD-SAML
# Re-create on every startup
#
NC_SAML_CLIENTID=$($KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep cloud\/apps\/user | cut -d "," -f1)
if [ ! -z $NC_SAML_CLIENTID ]; then
    echo -n "$T remove existing nextcloud-saml client... "
    $KCADM delete clients/$NC_SAML_CLIENTID -r ElexisEnvironment
fi

if [[ $ENABLE_NEXTCLOUD == true ]]; then
    echo -n "$T assert nextcloud-saml client ... "
    openssl req -nodes -new -x509 -keyout /nextcloud-saml-private.key -out /nextcloud-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Nextcloud"
    NC_SAML_PUBLIC_CERT=$(cat /nextcloud-saml-public.cert | sed '1,1d' | sed '$ d')

    NC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata -s 'attributes."saml.signing.certificate"='"$NC_SAML_PUBLIC_CERT" -s enabled=true -f keycloak/nextcloud-saml.json -i)
    echo "ok $NC_SAML_CLIENTID"
fi

#
# ELEXIS-RAP-OPENID
# Re-create on every startup
#
#
#
# TODO: Fix HTTP/HTTPS redirectUri Problem
#
#
#
ER_OPENID_CLIENTID=$($KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep elexis-rap-openid | cut -d "," -f1)
if [ ! -z $ER_OPENID_CLIENTID ]; then
    echo "$T remove existing elexis-rap-openid client... "
    $KCADM delete clients/$ER_OPENID_CLIENTID -r ElexisEnvironment
fi

if [[ $ENABLE_ELEXIS_RAP == true ]]; then
    echo -n "$T assert elexis-rap-openid client ... "
    ER_OPENID_CLIENT=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-rap-openid -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_RAP_CLIENT_SECRET -s 'redirectUris=["http://'$EE_HOSTNAME'/rap/*"]' -f keycloak/elexis-rap-openid.json -i)
    echo "ok $ER_OPENID_CLIENT"
fi

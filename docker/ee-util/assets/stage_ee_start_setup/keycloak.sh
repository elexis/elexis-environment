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
    $KCADM create realms -s realm=ElexisEnvironment -s enabled=true -s displayName=Elexis-Environment -s userManagedAccessAllowed=true -s sslRequired=none -i
    REALMID=$($KCADM get realms/ElexisEnvironment --fields id -c --format csv --noquotes)
    echo "ok $REALMID"
fi

#
# Provide Elexis-Environment realm keys to other services
#
echo -n "$T Output realm keys to /ElexisEnvironmentRealmKeys.json ..."
$KCADM get keys -r ElexisEnvironment >/ElexisEnvironmentRealmKeys.json

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
# NEXTCLOUD-SAML
# Re-create on every startup
#
NC_SAML_CLIENTID=$($KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep cloud\/apps\/user | cut -d "," -f1)
if [ ! -z $NC_SAML_CLIENTID ]; then
    echo -n "$T remove existing nextcloud saml-client... "
    $KCADM delete clients/$NC_SAML_CLIENTID -r ElexisEnvironment
fi

if [[ $ENABLE_NEXTCLOUD == true ]]; then
    echo -n "$T assert Nextcloud saml-client ... "
    openssl req -nodes -new -x509 -keyout /nextcloud-saml-private.key -out /nextcloud-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Nextcloud"
    NC_SAML_PUBLIC_CERT=$(cat /nextcloud-saml-public.cert | sed '1,1d' | sed '$ d')

    NC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata -s 'attributes."saml.signing.certificate"='"$NC_SAML_PUBLIC_CERT" -s enabled=true -f keycloak/nextcloud-saml.json -i)
    echo "ok $NC_SAML_CLIENTID"
fi
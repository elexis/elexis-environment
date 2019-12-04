#!/bin/bash
V=7.0.1
KCADM=/$V/kcadm.sh
T="[KEYCLOAK] "
echo "$T ====================================================================="

echo -n "$T"
RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD)
STATUS="$?"
LOOP_COUNT=0
while [ $STATUS != 0 ] 
do 
    echo "$T Waiting for keycloak [$STATUS] ($RESPONSE) ..."
    sleep 15
    RESPONSE=$($KCADM config credentials --server http://keycloak:8080/keycloak/auth --realm master --user KeycloakAdmin --client admin-cli --password $ADMIN_PASSWORD) 
    STATUS="$?"
    (( LOOP_COUNT += 1 ))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

#
# Assert Elexis-Environment Realm
#
REALMID=$($KCADM get realms/ElexisEnvironment --fields id -c --format csv --noquotes)
if [ -z $REALMID ]; then
    echo -n "$T create ElexisEnvironment realm ... "
    $KCADM create realms -s realm=ElexisEnvironment -s enabled=true -s displayName=Elexis-Environment -s userManagedAccessAllowed=true -s sslRequired=none -i
    REALMID=$($KCADM get realms/ElexisEnvironment --fields id -c --format csv --noquotes)
    echo "ok $REALMID"
fi

#
# Assert ldap user storage provider
#
LDAP_USP_ID=$($KCADM get components -r ElexisEnvironment --format csv --fields providerId,id,providerType --noquotes | grep org.keycloak.storage.UserStorageProvider$ | grep ^ldap | cut -d "," -f2)
if [ -z $LDAP_USP_ID ]; then
    echo -n "$T create ldap storage provider ... "
    LDAP_USP_ID=$($KCADM create components -r ElexisEnvironment -s name=ldap -s providerId=ldap -s providerType=org.keycloak.storage.UserStorageProvider -s parentId=$REALMID \
    -s 'config.bindCredential=["'$ADMIN_PASSWORD'"]' -s 'config.bindDn=["'cn=admin,$ORGANISATION_BASE_DN'"]' -f keycloak/ldap.json -i)
    echo "ok $LDAP_USP_ID"

    echo -n "$T create group-ldap-mapper ... "
    LDAP_UPS_GM_ID=$($KCADM create components -r ElexisEnvironment -s name=ldap_groups -s providerId=group-ldap-mapper -s providerType=org.keycloak.storage.ldap.mappers.LDAPStorageMapper \
    -s parentId=$LDAP_USP_ID -s 'config."groups.dn"=["'ou=groups,$ORGANISATION_BASE_DN'"]' -f keycloak/ldap_groups.json -i)
    echo "ok $LDAP_UPS_GM_ID"
fi

echo "$T trigger synchronization of all users ... "
$KCADM create -r ElexisEnvironment user-storage/$LDAP_USP_ID/sync?action=triggerFullSync

#
# Assert rocketchat client
#
echo -n "$T assert rocket-chat-client ... "
$KCADM create clients -r ElexisEnvironment -s clientId=rocket-chat-client -s baseUrl=/chat -s enabled=true -s secret=$X_EE_RC_OAUTH_CLIENT_SECRET -f keycloak/client_rocketchat.json -i
#!/usr/bin/env bats

#
# Test Keycloak configuration
#

export T="[KEYCLOAK] "

@test "$T Test API login as keycloak-local-user KeycloakAdmin (Master Realm)" {
    run curl -s -k -o /dev/null -sw '%{http_code}' -d "client_id=admin-cli" -d "username=KeycloakAdmin" -d "password=$ADMIN_PASSWORD" -d "grant_type=password" https://$EE_HOSTNAME/keycloak/auth/realms/master/protocol/openid-connect/token
    echo "output = ${output}"
    [ "$output" == "200" ]
}

@test "$T Test API login as ldap-user $ADMIN_USERNAME (ElexisEnvironment Realm)" {
    run curl -s -k -o /dev/null -sw '%{http_code}' -d "client_id=admin-cli" -d "username=$ADMIN_USERNAME" -d "password=$ADMIN_PASSWORD" -d "grant_type=password" https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/protocol/openid-connect/token
    echo "output = ${output}"
    [ "$output" == "200" ]
}

#@test "$T Trigger full user sync from ldap to keycloak (ElexisEnvironmentRealm)" {
#    TOKEN=$(curl -m 5 -s -k -d "client_id=admin-cli" -d "username=KeycloakAdmin" -d "password=$ADMIN_PASSWORD" -d "grant_type=password" https://$EE_HOSTNAME/keycloak/auth/realms/master/protocol/openid-connect/token |jq -r .access_token)
#    run curl -s -k -o /dev/null -sw '%{http_code}' -X POST -H "Authorization: bearer $TOKEN" https://$EE_HOSTNAME/keycloak/auth/admin/realms/ElexisEnvironment/user-storage/1da64dd8-e7cd-4f67-8ef9-3d7a29ec47fc/sync?action=triggerFullSync
#    echo "output = ${output}"
#    [ "$output" == "200" ]
#}
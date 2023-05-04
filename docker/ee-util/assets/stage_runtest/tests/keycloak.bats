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
#!/usr/bin/env bats

#
# Test RocketChat container
#
export T="[ROCKETCHAT] "

@test "$T Read https://$EE_HOSTNAME/chat" {
    run curl -m 5 -sw '%{http_code}' -o /dev/null -s -k https://$EE_HOSTNAME/chat
    [ "$output" == "200" ]
}

@test "$T Read setting with rocketchat-local-user RocketChatAdmin -> LDAP_Enable" {
    result="$(java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u https://$EE_HOSTNAME/chat -t LDAP_Enable)"
    echo "output = ${output}"
    [ "$result" == "true" ]
}

@test "$T Integration for elexis-server exists" {
    run java -jar /RocketchatTester.jar -t -l RocketChatAdmin -p $ADMIN_PASSWORD -u https://$EE_HOSTNAME/chat -x es_integration_exist
    echo "output = ${output}"
}

# Test if login works
@test "$T Test login via ldap and keycloak as demouser" {
    xvfb-run java -jar /SeleniumTester.jar -h $EE_HOSTNAME -l demouser -p demouser -rr -c /usr/bin/chromedriver 2>/dev/null
}
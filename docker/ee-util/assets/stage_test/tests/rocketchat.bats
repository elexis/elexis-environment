#!/usr/bin/env bats

#
# Test RocketChat container
#
export T="[ROCKETCHAT] "

@test "$T Read setting with rocketchat-local-user RocketChatAdmin -> LDAP_Enable" {
    result="$(java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u https://$EE_HOSTNAME/chat -t LDAP_Enable)"
    [ "$result" == "true" ]
}

@test "$T Integration for elexis-server exists" {
    java -jar /RocketchatTester.jar -t -l RocketChatAdmin -p $ADMIN_PASSWORD -u https://$EE_HOSTNAME/chat -x es_integration_exist
}

# test login as admin
@test "$T Login as demouser" {
    skip
    # https://github.com/RocketChat/Rocket.Chat/pull/14278
    curl -k https://$EE_HOSTNAME/chat/api/v1/login -d "user=demouser,password=demouser" 
}

# test login as demouser
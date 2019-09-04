#!/usr/bin/env bats

#
# Test Bookstack container
#

export T="[BOOKSTACK] "

@test "$T Login https://$EE_HOSTNAME/bookstack/login as demouser" {
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    run curl -sw '%{http_code}' -o /dev/null -s -k -L -b cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=demouser&password=demouser&_token=$TOKEN&checkbox=off"
    [ "$output" == "200" ]
}

@test "$T Login https://$EE_HOSTNAME/bookstack/login as $ADMIN_USERNAME" {
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    run curl -sw '%{http_code}' -o /dev/null -s -k -L -b cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=$ADMIN_USERNAME&password=$ADMIN_PASS&_token=$TOKEN&checkbox=off"
    [ "$output" == "200" ]
}

@test "$T Fail login https://$EE_HOSTNAME/bookstack/login" {
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    run curl -sw '%{http_code}' -o /dev/null -s -k -L -b cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=invaliduser&password=invalidpass&_token=$TOKEN&checkbox=off"
    [ "$status" -eq 7 ]
}
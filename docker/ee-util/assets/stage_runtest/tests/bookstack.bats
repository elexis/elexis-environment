#!/usr/bin/env bats

#
# Test Bookstack container
#

export T="[BOOKSTACK] "

@test "$T Login https://$EE_HOSTNAME/bookstack/login as demouser" {
    # fetch hidden token in form and cookies
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    # parse form to extract token
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    # request login with hidden token, user, pass and cookies, write new cookies
    LOGIN=$(curl -sw '%{http_code}' -o /dev/null -s -k -L -b cookies.txt -c cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=demouser&password=demouser&_token=$TOKEN&checkbox=off")
    # try to access resource, should return 200 - if login unsuccessfull redirects (302) to login window
    run curl -sw '%{http_code}' -o /dev/null -s -k -b cookies.txt https://$EE_HOSTNAME/bookstack/books
    echo "output = ${output}"
    [ "$output" == "200" ]
}

@test "$T Login https://$EE_HOSTNAME/bookstack/login as $ADMIN_USERNAME" {
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    LOGIN=$(curl -sw '%{http_code}' -o /dev/null -s -k -L -b cookies.txt -c cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=$ADMIN_USERNAME&password=$ADMIN_PASSWORD&_token=$TOKEN&checkbox=off")
    run curl -sw '%{http_code}' -o /dev/null -s -k -b cookies.txt https://$EE_HOSTNAME/bookstack/books
    echo "output = ${output}"
    [ "$output" == "200" ]
}

@test "$T Fail login https://$EE_HOSTNAME/bookstack/login as invaliduser" {
    TOKEN_ALL=$(curl -s -j -c cookies.txt -k https://$EE_HOSTNAME/bookstack/login |grep "input type=\"hidden")
    TOKEN=$(echo $TOKEN_ALL | tr -d '\"' | tr -d '>' | cut -d '=' -f 4)
    LOGIN=$(curl -sw '%{http_code}' -s -k -L -b cookies.txt -c cookies.txt https://$EE_HOSTNAME/bookstack/login -d "username=invaliduser&password=invalidpass&_token=$TOKEN&checkbox=off")
    run curl -sw '%{http_code}' -o /dev/null -s -k -b cookies.txt https://$EE_HOSTNAME/bookstack/books
    echo "output = ${output}"
    [ "$output" == "302" ]
    # redirects to login window
}
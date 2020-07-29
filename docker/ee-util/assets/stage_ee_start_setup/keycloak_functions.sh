#!/bin/bash
V=10.0.2
KCADM=/$V/kcadm.sh
S="[KEYCLOAK]"
T=$S

function getClientId () {
    $KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep $1 | cut -d "," -f1
}

# create or update a role for a client
# $1 client id
# $2 role name
# $3 params
function createOrUpdateClientRole () {
    CLIENT_ROLE_ID=$($KCADM get-roles -r ElexisEnvironment --cid $1 --format csv --fields id,name --noquotes | grep ,$2$ | cut -d "," -f1)
    if [ -z $CLIENT_ROLE_ID ];
    then
        echo -n "$T create role [$2]"
        $KCADM create clients/$1/roles -r ElexisEnvironment -s name=$2 -s "$3"
    else
        echo "$T update client role [$2]"
        $KCADM update clients/$1/roles/$2 -r ElexisEnvironment -s "$3"
    fi
}
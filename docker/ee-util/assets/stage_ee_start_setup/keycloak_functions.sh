#!/bin/bash
V=12.0.4
KCADM=/$V/kcadm.sh
S="[KEYCLOAK]"
T=$S

function getClientId() {
    $KCADM get clients -r ElexisEnvironment --format csv --fields id,clientId --noquotes | grep $1 | cut -d "," -f1
}

# create or update a role for a client
# $1 client id
# $2 role name
# $3 params
function createOrUpdateClientRole() {
    CLIENT_ROLE_ID=$($KCADM get-roles -r ElexisEnvironment --cid $1 --format csv --fields id,name --noquotes | grep ,$2$ | cut -d "," -f1)
    if [ -z $CLIENT_ROLE_ID ]; then
        echo -n "$T create role [$2]"
        $KCADM create clients/$1/roles -r ElexisEnvironment -s name=$2 -s "$3"
    else
        echo "$T update client role [$2]"
        $KCADM update clients/$1/roles/$2 -r ElexisEnvironment -s "$3"
    fi
}

# create saml mapper for a client
# $1 client id
# $2 mapper name
# $3 mapper type
function createSamlClientMapper() {
    CLIENT_MAPPER_ID=$($KCADM get clients/$1/protocol-mappers/models -r ElexisEnvironment --format csv --fields id,name --noquotes | grep ,$2$ | cut -d "," -f1)
    if [ -z $CLIENT_MAPPER_ID ]; then
        echo -n "$T create mapper [$2]"
        if [ "saml-javascript-mapper" = "$3" ]
        then
            $KCADM create clients/$1/protocol-mappers/models -r ElexisEnvironment -s name=$2 -s protocol=saml -s protocolMapper=$3 -f $4
        elif [ "saml-role-list-mapper" = "$3" ]
        then
            $KCADM create clients/$1/protocol-mappers/models -r ElexisEnvironment -s name=$2 -s protocol=saml -s protocolMapper=$3 -f $4
        else
            $KCADM create clients/$1/protocol-mappers/models -r ElexisEnvironment -s name=$2 -s protocol=saml -s protocolMapper=$3 -s 'config."attribute.nameformat"=Basic' -s 'config."user.attribute"='"$2" -s 'config."attribute.name"='"$2"
        fi
    fi
}

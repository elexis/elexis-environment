#!/bin/bash

KCADM=/ee-bin/keycloak/kcadm/kcadm.sh
KC_CONFIG_CLI_JAR=/ee-bin/keycloak/config-cli/keycloak-config-cli-24.0.5.jar

S="[KEYCLOAK]"
T=$S

function randomClientSecret {
    openssl rand -base64 33 | tr -- '+/' '-_'
}

function getUserId() {
    $KCADM get users -r ElexisEnvironment --format csv --fields id,username --noquotes | grep ,$1$ | cut -d "," -f1
}
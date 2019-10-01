#!/bin/bash

bats stage_test/tests/elexis-env.bats
bats stage_test/tests/ldap.bats
bats stage_test/tests/keycloak.bats
bats stage_test/tests/elexis-server.bats
if [[ $ENABLE_BOOKSTACK == true ]]; then
    bats stage_test/tests/bookstack.bats
fi
if [[ $ENABLE_ROCKETCHAT == true ]]; then
    bats stage_test/tests/rocketchat.bats
fi 
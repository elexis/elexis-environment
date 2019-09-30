#!/bin/bash

bats stage_test/tests/elexis-env.bats
bats stage_test/tests/ldap.bats
bats stage_test/tests/keycloak.bats
bats stage_test/tests/elexis-server.bats
[[ $ENABLE_BOOKSTACK == true ]] && bats stage_test/tests/bookstack.bats
[[ $ENABLE_ROCKETCHAT == true ]] && bats stage_test/tests/rocketchat.bats
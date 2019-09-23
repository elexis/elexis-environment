#!/bin/bash

bats stage_test/tests/elexis-env.bats
bats stage_test/tests/ldap.bats
bats stage_test/tests/keycloak.bats
bats stage_test/tests/bookstack.bats
bats stage_test/tests/elexis-server.bats
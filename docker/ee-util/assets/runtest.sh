#!/bin/bash

bats stage_runtest/tests/elexis-env.bats;  (( exit_status = exit_status || $? ))
bats stage_runtest/tests/keycloak.bats;  (( exit_status = exit_status || $? ))
bats stage_runtest/tests/elexis-server.bats;  (( exit_status = exit_status || $? ))
if [[ $ENABLE_BOOKSTACK == true ]]; then
    bats stage_runtest/tests/bookstack.bats;  (( exit_status = exit_status || $? ))
fi
if [[ $ENABLE_ROCKETCHAT == true ]]; then
    bats stage_runtest/tests/rocketchat.bats;  (( exit_status = exit_status || $? ))
fi 

exit $exit_status   # 0 if they all succeeded, 1 if any failed
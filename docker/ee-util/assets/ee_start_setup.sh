#!/bin/bash

cd /stage_ee_start_setup
T="[EE-UTIL] "
echo "$T Start configure Elexis-Environment"

./elexis_db.sh; (( exit_status = exit_status || $? ))

./keycloak.sh; (( exit_status = exit_status || $? ))

if [[ $ENABLE_ROCKETCHAT == true ]]; then
    ./rocketchat.sh; (( exit_status = exit_status || $? ))
fi

exit $exit_status   # 0 if they all succeeded, 1 if any failed
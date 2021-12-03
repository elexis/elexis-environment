#!/bin/bash

cd /stage_ee_start_setup
B="========================================================================================================"
T="[EE-UTIL] "
echo "$B"
echo "$T Start configure Elexis-Environment"
echo "$B"
./elexis_db.sh
((exit_status = exit_status || $?))
echo "$B"
./keycloak.sh
((exit_status = exit_status || $?))

if [[ $ENABLE_ROCKETCHAT == true ]]; then
    echo "$B"
    ./rocketchat.sh
    ((exit_status = exit_status || $?))
fi

if [[ $ENABLE_NEXTCLOUD == true ]]; then
    echo "$B"
    ./nextcloud.sh
    ((exit_status = exit_status || $?))
fi

if [[ $ENABLE_BOOKSTACK == true ]]; then
    echo "$B"
    ./bookstack.sh
    ((exit_status = exit_status || $?))
fi

exit $exit_status # 0 if they all succeeded, 1 if any failed

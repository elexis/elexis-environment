#!/bin/bash

cd /stage_ee_start_setup
./elexis_db.sh; (( exit_status = exit_status || $? ))
if [ -$ENABLE_ROCKETCHAT ]; then
    ./rocketchat.sh; (( exit_status = exit_status || $? ))
fi

exit $exit_status   # 0 if they all succeeded, 1 if any failed
#!/bin/bash

cd /stage_ee_start_setup
B="========================================================================================================"
T="[EE-UTIL] "
echo "$B"
echo "$T Start configure Elexis-Environment"


WIREGUARD_HOST=$(getent hosts wireguard | awk '{ print $1 }')
if [ -n "${WIREGUARD_HOST}" ]; then
    echo "$T [WG]---<=>---[WG_SERVICES] Adding wg_services route via $WIREGUARD_HOST"
    route add -net 10.101.0.0 netmask 255.255.0.0 gw $WIREGUARD_HOST
else 
    echo "Host wireguard not resolvable. Not adding wg_services route."
fi


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

if [[ $ENABLE_SOLR == true ]]; then
    echo "$B"
    ./solr.sh
    ((exit_status = exit_status || $?))
fi

exit $exit_status # 0 if they all succeeded, 1 if any failed

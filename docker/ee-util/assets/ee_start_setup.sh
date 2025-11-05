#!/bin/bash

# triggered by ./ee start or ./ee system reconfigure

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

check_status() {
    local name=$1
    local status=$2
    ((exit_status = exit_status || status))
    if [[ $status -ne 0 ]]; then
        echo "$T ERROR: $name failed with exit code $status"
    fi
}

echo "$B"
./elexis_db.sh
status=$?
check_status "elexis_db.sh" $status

echo "$B"
./keycloak.sh
status=$?
check_status "keycloak.sh" $status

if [[ $ENABLE_BOOKSTACK == true ]]; then
    echo "$B"
    ./bookstack.sh
    status=$?
    check_status "bookstack.sh" $status
fi

if [[ $ENABLE_SOLR == true ]]; then
    echo "$B"
    ./solr.sh
    status=$?
    check_status "solr.sh" $status
fi

if [[ $ENABLE_MATRIX == true ]]; then
    echo "$B"
    ./matrix.sh
    status=$?
    check_status "matrix.sh" $status
fi

exit $exit_status # 0 if they all succeeded, 1 if any failed

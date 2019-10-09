#!/usr/bin/env bats

#
# Test Elexis-Environment
#

export T="[ELEXIS-ENV] "

@test "$T Read https://$EE_HOSTNAME/.eenv.properties" {
    run curl -m 5 -sw '%{http_code}' -o /dev/null -s -k https://$EE_HOSTNAME/.eenv.properties
    [ "$output" == "200" ]
}

@test "Entry Config#EE_HOSTNAME is $EE_HOSTNAME" {
    MYSQL_STRING="SELECT WERT FROM CONFIG WHERE PARAM = 'EE_HOSTNAME'"
    run /usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -t -c "$MYSQL_STRING"
    echo "output = ${output}"
    [[ "$output" == *"$EE_HOSTNAME"* ]]
}
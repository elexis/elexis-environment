#!/usr/bin/env bats

#
# Test Elexis-Server container
#

export T="[ELEXIS-SERVER] "

@test "$T Read https://$EE_HOSTNAME/services/swagger.json" {
    run curl -sw '%{http_code}' -o /dev/null -s -k https://$EE_HOSTNAME/services/swagger.json
    [ "$output" == "200" ]
}
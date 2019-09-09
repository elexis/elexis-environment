#!/usr/bin/env bats

#
# Test Elexis-Environment
#

export T="[ELEXIS-ENV] "

@test "$T Read https://$EE_HOSTNAME/.eenv.properties" {
    run curl -sw '%{http_code}' -o /dev/null -s -k https://$EE_HOSTNAME/.eenv.properties
    [ "$output" == "200" ]
}
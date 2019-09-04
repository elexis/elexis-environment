#!/usr/bin/env bats

#
# Test LDAP container
#

export T="[LDAP] "

export PEOPLE_ADMIN="cn=$ADMIN_USERNAME,ou=people,$ORGANISATION_BASE_DN"
export PEOPLE_DEMOUSER="cn=demouser,ou=people,$ORGANISATION_BASE_DN"
export LDAPTLS_REQCERT=never

@test "$T Bind as cn=$ADMIN_USERNAME,$ORGANISATION_BASE_DN user -> search $PEOPLE_ADMIN" {
    result="$(ldapsearch -H ldaps://$EE_HOSTNAME -D cn=$ADMIN_USERNAME,$ORGANISATION_BASE_DN -w $ADMIN_PASS -x -b $ORGANISATION_BASE_DN uid=$ADMIN_USERNAME | grep dn)"
    [ "$result" == "dn: $PEOPLE_ADMIN" ]
}

@test "$T Bind as cn=$LDAP_READONLY_USER_USERNAME,$ORGANISATION_BASE_DN user -> search $PEOPLE_ADMIN" {
    result="$(ldapsearch -H ldaps://$EE_HOSTNAME -D cn=$LDAP_READONLY_USER_USERNAME,$ORGANISATION_BASE_DN -w $LDAP_READONLY_USER_PASSWORD -x -b $ORGANISATION_BASE_DN uid=$ADMIN_USERNAME | grep dn)"
    [ "$result" == "dn: $PEOPLE_ADMIN" ]
}

@test "$T Bind as $PEOPLE_ADMIN " {
    run ldapwhoami -H ldaps://$EE_HOSTNAME -D $PEOPLE_ADMIN -w $ADMIN_PASS -x
    [ "$output" = "dn:$PEOPLE_ADMIN" ]
}

@test "$T Bind as $PEOPLE_DEMOUSER " {
    run ldapwhoami -H ldaps://$EE_HOSTNAME -D $PEOPLE_DEMOUSER -w demouser -x
    [ "$output" = "dn:$PEOPLE_DEMOUSER" ]
}
#!/usr/bin/env bats

# Are all environment variables that are defined in .env.template covered in .eenv
@test ".env variables defines all .env.template variable keys" {
    run java -jar /EnvDiff.jar -s /installdir/.env.template -t /installdir/.env -d
    echo "output = ${output}"
    [ "$status" -eq 0 ]
}

# Is the Elexis DB accessible
@test "Check RDBMS_ELEXIS_DATABASE accessible" {
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "SELECT 1=1"
}

# Does an Elexis database exist here? New not yet supported.
@test "Check RDBMS_ELEXIS_DATABASE is populated (Config#ElexisVersion)" {
     MYSQL_STRING="SELECT WERT FROM CONFIG WHERE PARAM = 'ElexisVersion'"
    run /usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -t -c "$MYSQL_STRING"
    echo "output = ${output}"
    [[ "$output" == *"3."* ]]
}

# Is the Keycloak DB accessible
@test "Check RDBMS_KEYCLOAK_DATABASE accessible" {
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_KEYCLOAK_USERNAME}:${RDBMS_KEYCLOAK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_KEYCLOAK_DATABASE} -c "SELECT 1=1"
}

# Is the Bookstack DB accessible
@test "Check RDBMS_BOOKSTACK_DATABASE accessible" {
    if [[ $ENABLE_BOOKSTACK == false ]]; then
        skip "Bookstack module not enabled"
    fi
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_BOOKSTACK_USERNAME}:${RDBMS_BOOKSTACK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_BOOKSTACK_DATABASE} -c "SELECT 1=1"
}

# Is ADMIN_PASSWORD changed ( is it strong? )
@test "Admin password was changed" {
    [ "$ADMIN_PASSWORD" != "admin" ]
}

# Is EE_HOSTNAME resolvable
@test "Is $EE_HOSTNAME resolvable" {
    skip "DNS does not allow for internal IP to be registered - rethink this test"
    result="$(dig $EE_HOSTNAME +short)"
    [ ! -z "$result" ]
}

# Do the ssl keys exist?
@test "HTTPS key site/certificate.key available" {
    if [ ! -f "/site/certificate.key" ]; then
        skip "WARNING not available"
    fi
}

@test "HTTPS cert site/certificate.crt available" {
    if [ ! -f "/site/certificate.crt" ]; then
        skip "WARNING not available"
    fi
}

# Can an email be sent to ADMIN_EMAIL?
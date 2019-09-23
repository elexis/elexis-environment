#!/usr/bin/env bats

# Are all environment variables that are defined in .env.template covered in .eenv
@@test ".env variables cover all .env.template variables" {
    skip TODO 
}

# Is the Elexis DB accessible
@test "Check RDBMS_ELEXIS_DATABASE accessible" {
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "SELECT 1=1"
}

# Is the Bookstack DB accessible
@test "Check RDBMS_BOOKSTACK_DATABASE accessible" {
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_BOOKSTACK_USERNAME}:${RDBMS_BOOKSTACK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_BOOKSTACK_DATABASE} -c "SELECT 1=1"
}

# Is the Keycloak DB accessible
@test "Check RDBMS_KEYCLOAK_DATABASE accessible" {
    # Timeout??
    ./usql ${RDBMS_TYPE}://${RDBMS_KEYCLOAK_USERNAME}:${RDBMS_KEYCLOAK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_KEYCLOAK_DATABASE} -c "SELECT 1=1"
}

# Is ADMIN_PASSWORD changed ( is it strong? )
@test "Admin password was changed" {
    [ "$ADMIN_PASSWORD" != "admin" ]
}

# Is EE_HOSTNAME resolvable
@test "Is $EE_HOSTNAME resolvable" {
    result="$(dig $EE_HOSTNAME +short)"
    [ ! -z "$result" ]
}

# Do the ssl keys exist?
@test "HTTPS key assets/web/ssl/certificate.key available" {
    if [ ! -f "/assets/web/ssl/certificate.key" ]; then
        skip "WARNING not available"
    fi
}

@test "HTTPS cert assets/web/ssl/certificate.crt available" {
    if [ ! -f "/assets/web/ssl/certificate.crt" ]; then
        skip "WARNING not available"
    fi
}

# Can an email be sent to ADMIN_EMAIL?
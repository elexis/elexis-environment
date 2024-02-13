#!/bin/bash

#
# PERFORM DATABASE INITIALIZATIONS
#

#
# GUACAMOLE
#
if [ $ENABLE_GUACAMOLE == true ]; then
    MYSQL_STRING="SELECT EXISTS ( SELECT 1 FROM information_schema.tables WHERE table_schema = 'ee_guacamole' AND LOWER(table_name) = LOWER('guacamole_connection') ) AS TableExists;"
    timeout 5 /usql --set SHOW_HOST_INFORMATION=false -C mysql://${RDBMS_GUACAMOLE_USERNAME}:${RDBMS_GUACAMOLE_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_GUACAMOLE_DATABASE} -t -c "$MYSQL_STRING" -o /tmp/guac_exists_result.csv
    if grep -q "0" /tmp/guac_exists_result.csv; then
        echo "======== (Guacamole) Creating database"
        timeout 10 /usql mysql://${RDBMS_GUACAMOLE_USERNAME}:${RDBMS_GUACAMOLE_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_GUACAMOLE_DATABASE} -f /stage_configure/guacamole-init-mysql-db.sql
        echo "======== (Guacamole) Creating database done"
        echo "======== (Guacamole) Updating guacadmin password"
        # see https://guacamole.incubator.apache.org/doc/gug/jdbc-auth.html#modifying-data-manually
        MYSQL_STRING="SET @salt = UNHEX(SHA2(UUID(), 256)); UPDATE guacamole_user SET password_salt = @salt, password_hash = UNHEX(SHA2(CONCAT('"${ADMIN_PASSWORD}"', HEX(@salt)), 256)) WHERE (user_id = '1');"
        timeout 10 /usql --set SHOW_HOST_INFORMATION=false -C mysql://${RDBMS_GUACAMOLE_USERNAME}:${RDBMS_GUACAMOLE_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_GUACAMOLE_DATABASE} -t -c "$MYSQL_STRING"
        echo "======== (Guacamole) Updating guacadmin password done" 
    fi
    rm /tmp/guac_exists_result.csv
fi

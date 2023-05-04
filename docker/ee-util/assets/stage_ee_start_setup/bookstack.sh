#!/bin/bash
T="[BOOKSTACK] "
echo "$T $(date)"

#
# Update App Name in DB
#
echo -e "$T Update app name in database ..."
MYSQL_STRING="INSERT INTO settings (setting_key, value, created_at, updated_at, type)
    VALUES ('app-name', 'Praxishandbuch - ${ORGANISATION_NAME//__/\ }', current_timestamp, current_timestamp, 'string')
    ON DUPLICATE KEY UPDATE value='Praxishandbuch - ${ORGANISATION_NAME//__/\ }'"
/usql mysql://${RDBMS_BOOKSTACK_USERNAME}:${RDBMS_BOOKSTACK_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_BOOKSTACK_DATABASE} -c "$MYSQL_STRING"

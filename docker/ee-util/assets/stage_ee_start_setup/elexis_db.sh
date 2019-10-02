#!/bin/bash
# TODO other database systems
T="[ELEXIS-ENV] "
echo "$T Setting EE_HOSTNAME in elexis rdbms config table"
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_HOSTNAME', '${EE_HOSTNAME}') ON DUPLICATE KEY UPDATE wert = '${EE_HOSTNAME}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"
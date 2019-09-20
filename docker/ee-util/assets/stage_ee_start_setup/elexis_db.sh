#!/bin/bash
# TODO other database systems
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_HOSTNAME', '${EE_HOSTNAME}') ON DUPLICATE KEY UPDATE wert = '${EE_HOSTNAME}', lastupdate='${LASTUPDATE}'"
set -x
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"
echo $?
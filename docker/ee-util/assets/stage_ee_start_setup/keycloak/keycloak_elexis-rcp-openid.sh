#!/bin/bash
source keycloak_functions.sh
# Elexis-RCP Keycloak configuration script
T="$S (elexis-rcp-openid)"

echo "$T insert clientId/secret into elexis database .."
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RCP_OPENID_SECRET', '${SECRET_ELEXIS_RCP_JSON}') ON DUPLICATE KEY UPDATE wert = '${SECRET_ELEXIS_RCP_JSON}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

#!/bin/bash
# EMR Advanced Diagnostic Interface
# Server and RCP Application
T="[EMR-ADI-SERVER] "
echo "$T $(date)"

BASEURL="http://emr-adi-server:20141/services"

#
#
# Wait for login
#
#
LOOP_COUNT=0
while [[ "$(curl -s -o /dev/null -k -w ''%{http_code}'' --user admin.user:${ADMIN_PASSWORD} $BASEURL/swagger.json)" != "200" ]]; do
    echo "$T Waiting for emr-adi-server  ..."
    sleep 5
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

envsubst <emr-adi-server_synctemplate.json >emr-adi-server.json

#
#
# Basic configuration values to sync to elexis-server
# only if elexis-server is enabled
#
# delete existing sync if exists
curl -s --user admin.user:${ADMIN_PASSWORD} -X DELETE $BASEURL/fhirsync/endpoint/ee-elexis-server

if [ $ENABLE_ELEXIS_SERVER == "true" ]; then
    echo "$T Setting fhirsync to elexis-server  ..."
    # assert fhir sync exists
    curl -s --user admin.user:${ADMIN_PASSWORD} -X POST $BASEURL/fhirsync/endpoint -H "Content-Type: application/json" -d @emr-adi-server.json
else
    echo "$T elexis-server not enabled"
fi

export -n EMR_ADI_SERVER_SECRET_UUID
export -n EMR_ADI_SERVER_USER_NAME
export -n EMR_ADI_SERVER_USER_PASSWORD
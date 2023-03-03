#!/bin/bash
# EMR Advanced Diagnostic Interface
# Server and RCP Application
T="[EMR-ADI-SERVER] "
echo "$T $(date)"

BASEURL="http://emr-adi-server:20141/services"

if [ $ENABLE_ELEXIS_SERVER == "true" ]; then
    echo "$T Setting fhirsync to elexis-server  ..."
    # delete existing sync if exists
    curl -u "admin.user:${ADMIN_PASSWORD}" -X DELETE $BASEURL/fhirsync/endpoint/ee-elexis-server
    # assert fhir sync exists
    curl -u "admin.user:${ADMIN_PASSWORD}" -X POST $BASEURL/fhirsync/endpoint -H "Content-Type: application/json" -d @emr-adi-server_synctemplate.json
else 
    echo "$T elexis-server not enabled"
fi

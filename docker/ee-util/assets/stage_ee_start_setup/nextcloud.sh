#!/bin/bash
#
# Configure NextCloud for Elexis Operation
#
NC_BASEURL="https://$EE_HOSTNAME/cloud"
T="[NEXTCLOUD] "
echo "$T $(date)"

#
#
# Wait for login
#
#
LOOP_COUNT=0
while [[ "$(curl -s -o /dev/null -k -w ''%{http_code}'' -H "OCS-APIRequest: true" $NC_BASEURL/ocs/v2.php/cloud/capabilities)" != "200" ]]; do
    echo "$T Waiting for nextcloud  ..."
    sleep 5
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

#
#
# Basic configuration values
#
#
#echo -e "$T Assert basic configuration ..."
#java -jar /NextcloudSetter.jar -t -l NextcloudAdmin -p $ADMIN_PASSWORD -u $NC_BASEURL -v \
#    -s theming/name="${ORGANISATION_NAME//__/\ }" -s theming/url="$EE_HOSTNAME/cloud"
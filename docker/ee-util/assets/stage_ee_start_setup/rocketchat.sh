#!/bin/bash
#
# Configure Rocket.Chat for Elexis Operation
#

RC_BASEURL="http://rocketchat:3000/chat"
T="[ROCKETCHAT] ($RC_BASEURL) "

ping -c 1 rocketchat

# log-in
echo "$T Log-in as RocketChatAdmin..."
RESPONSE=$(curl -s $RC_BASEURL/api/v1/login -d "user=RocketChatAdmin&password=$ADMIN_PASSWORD")
ret=$?
if [ $ret -ne 0 ]
then
    echo "Exit code ($ret) with response ($RESPONSE)"
    exit -1
fi
AUTH_TOKEN=$(echo $RESPONSE | jq -r .data.authToken)
USER_ID=$(echo $RESPONSE | jq -r .data.me._id)

CURL_AUTH="-H \"X-Auth-Token: $AUTH_TOKEN\" -H \"X-User-Id: $USER_ID\""

echo "$T Assert channel #elexis-server..."
curl -s $CURL_AUTH -H "Content-type: application/json" $RC_BASEURL/api/v1/channels.create -d '{ "name": "elexis-server", "description": "Elexis-Server status messages" }'

echo -e "\n$T Assert bot user for elexis-user..."
curl -s $CURL_AUTH -H "Content-type: application/json" $RC_BASEURL/api/v1/users.create --data-binary @rocketchat/cr_es_user.json

echo -e "\n$T Assert bot avatar for elexis-server ..."
curl -s $CURL_AUTH -F "image=@rocketchat/elexis-server.png" -F "username=elexis-server" $RC_BASEURL/api/v1/users.setAvatar 

echo -e "\n$T Assert webhook integration for elexis-server..."
EX_INTEGRATIONS=$(curl -s $CURL_AUTH -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.list)
EXISTING=$(echo $EX_INTEGRATIONS | jq '.integrations[] | select(.name=="elexis-server-messages")')
if [ -z "$EXISTING" ]
then
    echo "Creating webhook ..."
    EXISTING=$(curl -s $CURL_AUTH -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.create --data-binary @rocketchat/cr_es_inc_webhook.json)
fi
echo $EXISTING

TOKEN=$(echo $EXISTING | jq -r .token)
ID=$(echo $EXISTING | jq -r ._id)
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RC_ES_INTEGRATION_WEBHOOK_TOKEN', '${ID}/${TOKEN}') ON DUPLICATE KEY UPDATE wert = '${ID}/${TOKEN}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

echo "$T Log-Out as RocketChatAdmin..."
curl -s $CURL_AUTH $RC_BASEURL/api/v1/logout
#!/bin/bash
#
# Configure Rocket.Chat for Elexis Operation
#

T="[ROCKETCHAT] "
RC_BASEURL=$"http://rocketchat:3000/chat"

# log-in
echo "$T Log-in as RocketChatAdmin..."
RESPONSE=$(curl -s -k $RC_BASEURL/api/v1/login -d "user=RocketChatAdmin&password=$ADMIN_PASSWORD")
if [ -z "$RESPONSE" ]
then
    echo "Error no response...."
    exit -1
fi
AUTH_TOKEN=$(echo $RESPONSE | jq -r .data.authToken)
USER_ID=$(echo $RESPONSE | jq -r .data.me._id)

echo "$T Assert channel #elexis-server..."
curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/channels.create -d '{ "name": "elexis-server", "description": "Elexis-Server status messages" }'

echo -e "\n$T Assert bot user for elexis-user..."
curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/users.create --data-binary @rocketchat/cr_es_user.json

echo -e "\n$T Assert bot avatar for elexis-server ..."
curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -F "image=@rocketchat/elexis-server.png" -F "username=elexis-server" $RC_BASEURL/api/v1/users.setAvatar 

echo -e "\n$T Assert webhook integration for elexis-server..."
EX_INTEGRATIONS=$(curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.list)
EXISTING=$(echo $EX_INTEGRATIONS | jq '.integrations[] | select(.name=="elexis-server-messages")')
if [ -z "$EXISTING" ]
then
    echo "Creating webhook ..."
    EXISTING=$(curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.create --data-binary @rocketchat/cr_es_inc_webhook.json)
fi
echo $EXISTING

TOKEN=$(echo $EXISTING | jq -r .token)
ID=$(echo $EXISTING | jq -r ._id)
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RC_ES_INTEGRATION_WEBHOOK_TOKEN', '${ID}/${TOKEN}') ON DUPLICATE KEY UPDATE wert = '${ID}/${TOKEN}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

echo "$T Log-Out as RocketChatAdmin..."
curl -s -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" $RC_BASEURL/api/v1/logout
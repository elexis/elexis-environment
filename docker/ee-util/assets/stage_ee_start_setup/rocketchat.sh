#!/bin/bash
#
# Configure Rocket.Chat for Elexis Operation
#
RC_BASEURL="http://rocketchat:3000/chat"
T="[ROCKETCHAT] "
echo "$T $(date)"

#
#
# Wait for login
#
#
echo "$T Log-in as RocketChatAdmin..."
RESPONSE=$(curl -s -k $RC_BASEURL/api/v1/login -d "user=RocketChatAdmin&password=$ADMIN_PASSWORD")
STATUS="$?"
LOOP_COUNT=0
while [ $STATUS != 0 ]; do
    echo "$T Waiting for rocketchat [$STATUS] ($RESPONSE) ..."
    sleep 15
    RESPONSE=$(curl -s -k $RC_BASEURL/api/v1/login -d "user=RocketChatAdmin&password=$ADMIN_PASSWORD")
    STATUS="$?"
    ((LOOP_COUNT += 1))
    if [ $LOOP_COUNT -eq 20 ]; then exit -1; fi
done

AUTH_TOKEN=$(echo $RESPONSE | jq -r .data.authToken)
USER_ID=$(echo $RESPONSE | jq -r .data.me._id)

#
#
# Assert Styling
#
#
echo "$T Assert asset.logo image (Theme setup) ... "
# https://rocket.chat/docs/developer-guides/rest-api/assets/setasset/
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -F "logo=@rocketchat/theme/ee-logo-2x.png" $RC_BASEURL/api/v1/assets.setAsset
echo "\n"

#
#
# Load custom favicon
#
#
echo "$T Assert asset.favicon image (Theme setup) ... "
# https://rocket.chat/docs/developer-guides/rest-api/assets/setasset/
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -F "favicon=@rocketchat/theme/favicon.svg" $RC_BASEURL/api/v1/assets.setAsset
echo "\n"
echo "Use SVG favicon ... "
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v \
    -s Assets_SvgFavicon_Enable=true

#
#
# Load Custom CSS (Theme setup)
#
#
echo "$T Assert Custom CSS (Theme setup) ... "
THEME_CSS=$(cat ./rocketchat/theme/theme-custom.css)
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v \
    -s theme-custom-css="$THEME_CSS"
echo "\n"

#
#
# Load Custom_Script_Logged_In (Theme setup)
#
#
echo "$T Assert Custom_Script_Logged_In (Theme setup) ... "
THEME_JS=$(cat ./rocketchat/theme/theme-custom.min.js)
SHA_256_HASH=$(echo -n $ADMIN_PASSWORD | sha256sum | cut -d' ' -f 1)
# https://developer.rocket.chat/api/rest-api/methods/settings/update
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "X-2fa-code: $SHA_256_HASH" -H "X-2fa-method: password" -H "Content-type: application/json" $RC_BASEURL/api/v1/settings/Custom_Script_Logged_In -d '{"value":"'"$THEME_JS"'"}'
echo "\n"

#
#
# Basic configuration values
#
#
echo "$T Assert basic configuration ... "
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v \
    -s Accounts_PasswordReset=false \
    -s Accounts_RegistrationForm=Disabled \
    -s Accounts_RegistrationForm_LinkReplacementText="" \
    -s API_Enable_Rate_Limiter_Limit_Calls_Default=100 \
    -s Site_Name="Chat - ${ORGANISATION_NAME//__/\ }" \
    -s Organization_Name="${ORGANISATION_NAME//__/\ }" \
    -s SMTP_Host="${EE_HOST_INTERNAL_IP}" \
    -s SMTP_Port="25" \
    -s From_Email="rocketchat@${EE_HOSTNAME}" \
    -s RetentionPolicy_Enabled=true

#
#
# Assert Keycloak SAML Integration
#
#
echo "$T Assert Keycloak SAML integration ... "
REALM_CERT=$(jq '.keys[] | select(.algorithm == "RS256") | select(.status == "ACTIVE") | .certificate' -r /ElexisEnvironmentRealmKeys.json)
RC_PRIVATE_KEY=$(cat /rocketchat-saml-private.key)
RC_PUBLIC_CERT=$(cat /rocketchat-saml-public.cert)
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v \
    -s SAML_Custom_Default=true \
    -s SAML_Custom_Default_provider=rocketchat-saml \
    -s SAML_Custom_Default_entry_point=https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/protocol/saml \
    -s SAML_Custom_Default_idp_slo_redirect_url=/keycloak/auth/realms/ElexisEnvironment/protocol/saml \
    -s SAML_Custom_Default_issuer=rocketchat-saml \
    -s SAML_Custom_Default_button_label_text=Elexis-Environment \
    -s SAML_Custom_Default_cert="$REALM_CERT" \
    -s SAML_Custom_Default_logout_behaviour=Local \
    -s SAML_Custom_Default_name_overwrite=true \
    -s SAML_Custom_Default_mail_overwrite=true \
    -s SAML_Custom_Default_generate_username=false \
    -s SAML_Custom_Default_immutable_property=Username \
    -s SAML_Custom_Default_public_cert="$RC_PUBLIC_CERT" \
    -s SAML_Custom_Default_private_key="$RC_PRIVATE_KEY"

#
#
# Assert Elexis-Server Webhook/Channel Integration
#
#
echo -e "\n$T Assert Elexis-Server - channel #elexis-server ..."
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/channels.create -d '{ "name": "elexis-server", "description": "Elexis-Server status messages" }'

echo -e "\n$T Assert Elexis-Server - bot user for elexis-user ..."
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/users.create --data-binary @rocketchat/cr_es_user.json

echo -e "\n$T Assert Elexis-Server - bot avatar for elexis-server ..."
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -F "image=@rocketchat/elexis-server.png" -F "username=elexis-server" $RC_BASEURL/api/v1/users.setAvatar

echo -e "\n$T Assert Elexis-Server - webhook integration for elexis-server..."
EX_INTEGRATIONS=$(curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.list)
EXISTING=$(echo $EX_INTEGRATIONS | jq '.integrations[] | select(.name=="elexis-server-messages")')
if [ -z "$EXISTING" ]; then
    echo "Creating webhook ..."
    EXISTING=$(curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" -H "Content-type: application/json" $RC_BASEURL/api/v1/integrations.create --data-binary @rocketchat/cr_es_inc_webhook.json)
fi
echo $EXISTING

#
#
# Pre-Configure Federation
#
#
echo "$T Print Federation Public Key ..."
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v FEDERATION_Public_Key
echo "$T Set Federation domain ..."
java -jar /RocketchatSetting.jar -l RocketChatAdmin -p $ADMIN_PASSWORD -u $RC_BASEURL -v -s FEDERATION_Domain=$EE_HOSTNAME

#
#
# Log Out
#
#
echo "$T Log-Out as RocketChatAdmin..."
curl -s -k -H "X-Auth-Token: $AUTH_TOKEN" -H "X-User-Id: $USER_ID" $RC_BASEURL/api/v1/logout

TOKEN=$(echo $EXISTING | jq -r .token)
ID=$(echo $EXISTING | jq -r ._id)
LASTUPDATE=$(date +%s)000
MYSQL_STRING="INSERT INTO CONFIG(lastupdate, param, wert) VALUES ('${LASTUPDATE}','EE_RC_ES_INTEGRATION_WEBHOOK_TOKEN', '${ID}/${TOKEN}') ON DUPLICATE KEY UPDATE wert = '${ID}/${TOKEN}', lastupdate='${LASTUPDATE}'"
/usql mysql://${RDBMS_ELEXIS_USERNAME}:${RDBMS_ELEXIS_PASSWORD}@${RDBMS_HOST}:${RDBMS_PORT}/${RDBMS_ELEXIS_DATABASE} -c "$MYSQL_STRING"

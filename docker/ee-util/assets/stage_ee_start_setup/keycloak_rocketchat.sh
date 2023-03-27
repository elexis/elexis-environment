#!/bin/bash
source keycloak_functions.sh
#
# ROCKETCHAT-SAML
#
T="$S (rocketchat-saml)"
RC_SAML_CLIENTID=$(getClientId rocketchat-saml\$)
if [ -z $RC_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    RC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=rocketchat-saml -i)
    echo "ok $RC_SAML_CLIENTID"
fi

echo "$T update client settings ... "
openssl req -nodes -new -x509 -days 730 -keyout /rocketchat-saml-private.key -out /rocketchat-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Rocketchat"
RC_SAML_PUBLIC_CERT=$(cat /rocketchat-saml-public.cert | sed '1,1d' | sed '$ d')
$KCADM update clients/$RC_SAML_CLIENTID -r ElexisEnvironment -s clientId=rocketchat-saml -s 'attributes."saml.signing.certificate"='"$RC_SAML_PUBLIC_CERT" -s adminUrl=https://$EE_HOSTNAME/chat/_saml_metadata/rocketchat-saml -f keycloak/rocketchat-saml.json
# see https://rocket.chat/docs/administrator-guides/permissions/ for full list, only using relevant roles
createOrUpdateClientRole $RC_SAML_CLIENTID user 'description=Normal user rights. Most users receive this role when registering.'
createOrUpdateClientRole $RC_SAML_CLIENTID admin 'description=Have access to all settings and administrator tools.'
createOrUpdateClientRole $RC_SAML_CLIENTID livechat-agent 'description=Agents of livechat. They can answer to livechat requests.'
createOrUpdateClientRole $RC_SAML_CLIENTID livechat-manager 'description=Manager of livechat, they can manage agents and guest.'
echo "$T update client enabled=$ENABLE_ROCKETCHAT"
$KCADM update clients/$RC_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_ROCKETCHAT
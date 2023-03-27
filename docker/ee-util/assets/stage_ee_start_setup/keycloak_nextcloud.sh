#!/bin/bash
source keycloak_functions.sh
#
# NEXTCLOUD-SAML
#
T="$S (nexctcloud-saml)"
NC_SAML_CLIENTID=$(getClientId cloud\/apps\/user)
if [ -z $NC_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    NC_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata  -i)
    echo "ok $NC_SAML_CLIENTID"
fi

echo "$T update client settings ... "
openssl req -nodes -new -x509 -keyout /nextcloud-saml-private.key -out /nextcloud-saml-public.cert -subj "/C=CH/ST=$ORGANISATION_NAME/L=SAML/O=Nextcloud"
NC_SAML_PUBLIC_CERT=$(cat /nextcloud-saml-public.cert | sed '1,1d' | sed '$ d')
$KCADM update clients/$NC_SAML_CLIENTID -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/cloud/apps/user_saml/saml/metadata -s 'attributes."saml.signing.certificate"='"$NC_SAML_PUBLIC_CERT" -f keycloak/nextcloud-saml.json
echo "$T update client enabled=$ENABLE_NEXTCLOUD"
$KCADM update clients/$NC_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_NEXTCLOUD
createSamlClientMapper $NC_SAML_CLIENTID username saml-user-property-mapper
createSamlClientMapper $NC_SAML_CLIENTID email saml-user-property-mapper
createSamlClientMapper $NC_SAML_CLIENTID nextcloudquota saml-user-property-mapper
# No further support as of Keycloak 18, find replacement in due time
# createSamlClientMapper $NC_SAML_CLIENTID cn saml-javascript-mapper keycloak/nextcloud-saml-mapper-cn.json
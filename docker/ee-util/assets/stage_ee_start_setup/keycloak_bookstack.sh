#!/bin/bash
source keycloak_functions.sh
#
# BOOKSTACK-SAML
#
T="$S (bookstack-saml)"
BS_SAML_CLIENTID=$(getClientId bookstack\/saml2\/metadata)
if [ -z $BS_SAML_CLIENTID ]; then
    echo -n "$T create client ... "
    BS_SAML_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/bookstack/saml2/metadata -i)
    echo "ok $BS_SAML_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$BS_SAML_CLIENTID -r ElexisEnvironment -s clientId=https://$EE_HOSTNAME/bookstack/saml2/metadata -f keycloak/bookstack-saml.json
createSamlClientMapper $BS_SAML_CLIENTID firstName saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID lastName saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID username saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID email saml-user-property-mapper
createSamlClientMapper $BS_SAML_CLIENTID role saml-role-list-mapper keycloak/bookstack-saml-mapper-role.json
createOrUpdateClientRole $BS_SAML_CLIENTID admin 'description=Administrator of the whole application'
createOrUpdateClientRole $BS_SAML_CLIENTID editor 'description=User can edit Books, Chapters & Pages'
createOrUpdateClientRole $BS_SAML_CLIENTID viewer 'description=User can view books & their content behind authentication'
createOrUpdateClientRole $BS_SAML_CLIENTID public 'description=The role given to public visitors if allowed'
echo "$T update client enabled=$ENABLE_BOOKSTACK"
$KCADM update clients/$BS_SAML_CLIENTID -r ElexisEnvironment -s enabled=$ENABLE_BOOKSTACK
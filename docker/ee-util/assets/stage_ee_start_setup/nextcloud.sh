#!/bin/bash
#
# Configure NextCloud for Elexis Operation
#
NC_CONFIG_BASEURL="https://web/cloud/ocs/v2.php/apps/provisioning_api/api/v1/config"
NC_BASEURL="https://web/cloud"
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
echo -e "$T Assert basic configuration ..."
java -jar /NextcloudSetter.jar -t -l NextcloudAdmin -p $ADMIN_PASSWORD -u $NC_BASEURL -v \
    -s theming/name="Dateien - ${ORGANISATION_NAME//__/\ }" -s theming/url="$EE_HOSTNAME/cloud"

#
#
# Assert SAML
#
#
echo -e "$T Assert saml configuration ..."
REALM_CERT=$(jq '.keys[] | select(.algorithm == "RS256") | select(.status == "ACTIVE") | .certificate' -r /ElexisEnvironmentRealmKeys.json)
NC_PRIVATE_KEY=$(cat /nextcloud-saml-private.key)
NC_PUBLIC_CERT=$(cat /nextcloud-saml-public.cert)

java -jar /NextcloudSetter.jar -t -l NextcloudAdmin -p $ADMIN_PASSWORD -u $NC_BASEURL -v \
    -s user_saml/type="saml" \
    -s user_saml/general-allow_multiple_user_back_ends="1" \
    -s user_saml/general-idp0_display_name="Elexis-Environment" \
    -s user_saml/general-uid_mapping="username" \
    -s user_saml/general-use_saml_auth_for_desktop="1" \
    -s user_saml/idp-entityId="https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment" \
    -s user_saml/idp-singleLogoutService.url="https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/protocol/saml" \
    -s user_saml/idp-singleSignOnService.url="https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/protocol/saml" \
    -s user_saml/idp-x509cert="-----BEGIN CERTIFICATE-----$REALM_CERT-----END CERTIFICATE-----" \
    -s user_saml/providerIds="1" \
    -s user_saml/saml-attribute-mapping-displayName_mapping="cn" \
    -s user_saml/saml-attribute-mapping-email_mapping="email" \
    -s user_saml/saml-attribute-mapping-quota_mapping="nextcloudquota" \
    -s user_saml/security-authnRequestsSigned="1" \
    -s user_saml/security-logoutRequestSigned="1" \
    -s user_saml/security-logoutResponseSigned="1" \
    -s user_saml/security-signMetadata="0" \
    -s user_saml/security-wantAssertionsSigned="1" \
    -s user_saml/security-wantMessagesSigned="1" \
    -s user_saml/sp-name-id-format="urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified" \
    -s user_saml/sp-privateKey="$NC_PRIVATE_KEY" \
    -s user_saml/sp-x509cert="$NC_PUBLIC_CERT"

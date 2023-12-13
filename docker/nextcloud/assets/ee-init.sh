#!/bin/sh
echo "$(date): Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud

OCC="php /var/www/html/occ"

# EE UI Customization
echo "$(date): Copy EE customization files"
cp -R /var/www/acom_custom_js_css /var/www/html/apps
cp /var/www/core/img/logo/logo.svg /var/www/html/core/img/logo/logo.svg
cp /var/www/core/img/logo/logo.png /var/www/html/core/img/logo/logo.png
cp /var/www/core/img/logo/logo.png /var/www/html/core/doc/user/_static/logo-white.png
cp /var/www/core/img/logo/logo.png /var/www/html/core/doc/admin/_static/logo-white.png
cp /var/www/core/doc/user/_static/custom.css /var/www/html/core/doc/user/_static/custom.css
cp /var/www/core/doc/user/_static/custom.css /var/www/html/core/doc/admin/_static/custom.css
echo "$(date): Assert acom_custom_js_css app is enabled ..."
$OCC app:enable acom_custom_js_css
## END

echo "$(date): Assert user_oidc app is installed ..."
$OCC app:install user_oidc
echo "$(date): Configure user_oidc ..."
# Accept keycloak to be on localhost address
$OCC config:system:set allow_local_remote_servers --value true
# https://github.com/nextcloud/user_oidc
$OCC user_oidc:provider -c nextcloud -s $X_EE_NEXTCLOUD_CLIENT_SECRET \
    -d https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/.well-known/openid-configuration \
    --mapping-uid=preferred_username --check-bearer=1 --unique-uid=0 \
    --mapping-email=email Keycloak
# https://github.com/nextcloud/user_oidc#id4me-option
$OCC config:app:set --value=0 user_oidc id4me_enabled

echo "$(date): Apply theming ..."
$OCC config:app:set theming name --value "${ORGANISATION_NAME//__/\ }"

echo "$(date): App management ..."
$OCC app:install groupfolders
$OCC app:disable dashboard
$OCC app:disable weather_status
$OCC app:disable circles
$OCC app:disable firstrunwizard
$OCC app:disable federation
$OCC app:disable survey_client

echo "$(date): Set cron as background job manager ..."
$OCC background:cron

echo "$(date): Check big int conversion ..."
$OCC db:convert-filecache-bigint
echo "$(date): Check indices ..."
$OCC db:add-missing-indices
echo "$(date): Add missing optional columns ..."
$OCC db:add-missing-columns
echo "$(date): Set enforce default theme ..."
$OCC config:system:set enforce_theme --value=default

# https://github.com/nextcloud/groupfolders
echo "$(date): Assert groupfolders existence ..."
EXISTING_GROUPFOLDERS=$($OCC groupfolders:list --output=json | jq .[] | jq -r ."mount_point")
while IFS= read -r line; do
    FOLDER_NAME=$(echo "$line" | cut -d';' -f1)
    if echo "$EXISTING_GROUPFOLDERS" | grep -q "$FOLDER_NAME"; then
        echo -e ""
    else
        echo "Create groupfolder $FOLDER_NAME ..."
        FOLDER_ID=$($OCC groupfolders:create --no-ansi $FOLDER_NAME)
        # TODO role right mapping
        $OCC groupfolders:group $FOLDER_ID user write
    fi
done < "/groupfolders.csv"


# we have to return 0, as calling script is set -e
# which will exit if user_saml is already installed (return code)
return 0

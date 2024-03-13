#!/bin/bash
echo "$(date): Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud

OCC="php /var/www/html/occ"

# EE UI Customization
# TODO UPDATE
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
# https://github.com/nextcloud/user_oidc/issues/791
PROVIDER_ID=$($OCC user_oidc:provider --output json "Keycloak" | jq .id -r)
$OCC config:app:set user_oidc "provider-${PROVIDER_ID}-groupProvisioning" --value 1
$OCC config:app:set user_oidc "provider-${PROVIDER_ID}-bearerProvisioning" --value 1
$OCC config:app:set user_oidc "provider-${PROVIDER_ID}-mappingGroups" --value "nextcloud-groups"
# https://github.com/nextcloud/user_oidc#id4me-option
$OCC config:app:set user_oidc id4me_enabled --value=0

#https://github.com/nextcloud/user_oidc?tab=readme-ov-file#disable-other-login-methods
# use https://EE_HOSTNAME/cloud/index.php?direct=1
$OCC config:app:set user_oidc allow_multiple_user_backends --value=0

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
# try updates
$OCC app:update groupfolders


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

# need to assert groups exist, as they are
# required for groupfolder right assignment
echo "$(date): Asserting group existence ..."
$OCC group:add medical-practitioner
$OCC group:add medical-assistant
$OCC group:add bot
$OCC group:add mpa
$OCC group:add mpk
$OCC group:add third-party

# https://github.com/nextcloud/groupfolders
echo "$(date): Assert groupfolders existence ..."
EXISTING_GROUPFOLDERS=$($OCC groupfolders:list --output=json | jq .[] | jq -r ."mount_point")
while IFS= read -r line; do
    FOLDER_NAME=$(echo "$line" | cut -d';' -f1)
    FOLDER_GROUPRIGHTS=$(echo "$line" | cut -d';' -f2)
    if ! echo "$EXISTING_GROUPFOLDERS" | grep -q "$FOLDER_NAME"; then
        # we do not update groupfolders, we only
        # create them with default group/right mapping
        echo "Create groupfolder $FOLDER_NAME ..."
        FOLDER_ID=$($OCC groupfolders:create --no-ansi $FOLDER_NAME)

        IFS=',' read -ra GROUPRIGHTS <<< "$FOLDER_GROUPRIGHTS"
        for entry in "${GROUPRIGHTS[@]}"; do
            IFS=':' read -ra PARTS <<< "$entry"
            GROUP="${PARTS[0]}"
            RIGHT="read ${PARTS[1]}"
            echo "Setting groupfolder $FOLDER_NAME group $GROUP rights ..."
            $OCC groupfolders:group $FOLDER_ID $GROUP $RIGHT
        done
    fi
done < "/groupfolders.csv"

echo "$(date) Configure Nextcloud Office ..."
$OCC app:install richdocuments
$OCC app:update richdocuments
$OCC config:app:set --value https://${EE_HOSTNAME} richdocuments wopi_url
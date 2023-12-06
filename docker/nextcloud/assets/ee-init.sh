#!/bin/sh
echo "$(date): Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud

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
php /var/www/html/occ app:enable acom_custom_js_css
## END

echo "$(date): Assert user_oidc app is installed ..."
php /var/www/html/occ app:install user_oidc
echo "$(date): Configure user_oidc ..."
# Accept keycloak to be on localhost address
php /var/www/html/occ config:system:set allow_local_remote_servers --value true
# https://github.com/nextcloud/user_oidc
php /var/www/html/occ user_oidc:provider -c nextcloud -s $X_EE_NEXTCLOUD_CLIENT_SECRET \
    -d https://$EE_HOSTNAME/keycloak/auth/realms/ElexisEnvironment/.well-known/openid-configuration \
    --mapping-uid=preferred_username --check-bearer=1 --unique-uid=0 \
    --mapping-email=email Keycloak
# https://github.com/nextcloud/user_oidc#id4me-option
php /var/www/html/occ config:app:set --value=0 user_oidc id4me_enabled

echo "$(date): Apply theming ..."
php /var/www/html/occ config:app:set theming name --value "${ORGANISATION_NAME//__/\ }"

echo "$(date): App management ..."
php /var/www/html/occ app:install groupfolders
php /var/www/html/occ app:disable dashboard
php /var/www/html/occ app:disable weather_status
php /var/www/html/occ app:disable circles
php /var/www/html/occ app:disable firstrunwizard
php /var/www/html/occ app:disable federation
php /var/www/html/occ app:disable survey_client

echo "$(date): Set cron as background job manager ..."
php /var/www/html/occ background:cron

echo "$(date): Check big int conversion ..."
php /var/www/html/occ db:convert-filecache-bigint
echo "$(date): Check indices ..."
php /var/www/html/occ db:add-missing-indices
echo "$(date): Add missing optional columns ..."
php /var/www/html/occ db:add-missing-columns
echo "$(date): Set enforce default theme ..."
php /var/www/html/occ config:system:set enforce_theme --value=default

# we have to return 0, as calling script is set -e
# which will exit if user_saml is already installed (return code)
return 0

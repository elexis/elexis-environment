#!/bin/sh
until nc -z -v -w30 $MYSQL_HOST 3306
do
  echo "Waiting for database connection..."
  sleep 5
done

echo "$(date): Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud

echo "$(date): Copy files"
cp -R /var/www/acom_custom_js_css /var/www/html/apps
# Logo
cp /var/www/core/img/logo/logo.svg /var/www/html/core/img/logo/logo.svg
cp /var/www/core/img/logo/logo.png /var/www/html/core/img/logo/logo.png
cp /var/www/core/img/logo/logo.png /var/www/html/core/doc/user/_static/logo-white.png
cp /var/www/core/img/logo/logo.png /var/www/html/core/doc/admin/_static/logo-white.png
# Custom doc css
cp /var/www/core/doc/user/_static/custom.css /var/www/html/core/doc/user/_static/custom.css
cp /var/www/core/doc/user/_static/custom.css /var/www/html/core/doc/admin/_static/custom.css

echo "$(date): Assert user_saml app is installed ..."
php /var/www/html/occ app:install user_saml
echo "$(date): Assert acom_custom_js_css app is enabled ..."
php /var/www/html/occ app:enable acom_custom_js_css
echo "$(date): Check big int conversion ..."
php /var/www/html/occ db:convert-filecache-bigint
echo "$(date): Check indices ..."
php /var/www/html/occ db:add-missing-indices
echo "$(date): Add missing optional columns ..."
php /var/www/html/occ db:add-missing-columns
echo "$(date): Set enforce default theme ..."
php /var/www/html/occ config:system:set enforce_theme --value=default
# TODO external storage support aktivieren?

# we have to return 0, as calling script is set -e
# which will exit if user_saml is already installed (return code)
return 0

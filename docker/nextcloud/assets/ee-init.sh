#!/bin/sh
echo "Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud
echo "Asser user_saml app is installed ..."
php /var/www/html/occ app:install user_saml
echo "Check big int conversion ..."
php /var/www/html/occ db:convert-filecache-bigint
echo "Check indices ..."
php /var/www/html/occ db:add-missing-indices

# we have to return 0, as calling script is set -e
# which will exit if user_saml is already installed (return code)
return 0

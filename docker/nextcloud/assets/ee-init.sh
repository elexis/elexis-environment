#!/bin/sh
echo "$(date): Elexis-Environment specific setup"
ln -sf /var/www/html /var/www/html/cloud
echo "$(date): Assert user_saml app is installed ..."
php /var/www/html/occ app:install user_saml
echo "$(date): Check big int conversion ..."
php /var/www/html/occ db:convert-filecache-bigint
echo "$(date): Check indices ..."
php /var/www/html/occ db:add-missing-indices

# TODO external storage support aktivieren?

# we have to return 0, as calling script is set -e
# which will exit if user_saml is already installed (return code)
return 0

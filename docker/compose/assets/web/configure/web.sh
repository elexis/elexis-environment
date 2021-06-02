#!/bin/bash
#

#
# Setup Web config
#
#
echo "Setup Web config"
echo "{\"ENABLE_BOOKSTACK\":$2,\"ENABLE_ROCKETCHAT\":$3,\"ENABLE_NEXTCLOUD\":$4,\"ENABLE_ELEXIS_RAP\":$5,\"ENABLE_SOLR\":$6,\"ENABLE_OCRMYPDF\":$7}" > /usr/share/nginx/html/public/web-config.json

#
#
# Setup ORGANISATION_NAME for Landing page
#
#
echo "Setup ORGANISATION_NAME for Landing page"
ORGNAME=$(echo "$1" | sed "s/__/ /g")
sed -i "s/ORGANISATION NAME/$ORGNAME/g" /usr/share/nginx/html/public/index.html

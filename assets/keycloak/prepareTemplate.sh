#!/bin/bash
# THIS IS ONLY USED DURING DEVELOPMENT
set -x
sed -i '' 's/cn=admin,dc=mustermann,dc=ch/cn=${ADMIN_USERNAME},${ORGANISATION_BASE_DN}/g' realm.template.json
sed -i '' 's/dc=mustermann,dc=ch/${ORGANISATION_BASE_DN}/g' realm.template.json
sed -i '' 's/replace_with_hostname/${EE_HOSTNAME}/g' realm.template.json
grep -in -A2 "bindCredential" realm.template.json
echo "---------"
grep -in -A4 "rocket-chat-client" realm.template.json
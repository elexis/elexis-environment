#!/bin/sh
set -e
set -x

rocketchatsetting()
{
 java -jar RocketchatSetting.jar -u http://rocketchat:3000/chat -l ${ADMIN_USERNAME} -p ${ADMIN_PASS} -s -v $@
}

wikijssetting() 
{
 # configure directly per sql
 # TODO replace this with API resp. calls in the future
 cat $1 | envsubst | tee /tmp/usql_tmp.sql
 /usql ${DB_TYPE}://${DB_USER}:${DB_PASS}@${DB_HOST}:${DB_PORT}/${DB_NAME} -f /tmp/usql_tmp.sql
 rm /tmp/usql_tmp.sql
}

echo "===[ Rocketchat Configuration ]==="
rocketchatsetting $(tr -s '\n' ' ' < /rocketchatsetting.txt)

echo "===[ WikiJs Configuration ]==="
export NOW_ISO=$(date --utc +%FT%T.000Z)
export ENCRYPTED_PASS=$(echo -n ${WIKI_INITIAL_ADMIN_PASS} | /bcrypt-cli) # bcrypt version 2a, 12 rounds
wikijssetting /01_wikijs_init.template.sql
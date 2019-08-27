#!/bin/sh
set -e
set -x

rocketchatsetting()
{
 java -jar RocketchatSetting.jar -u http://rocketchat:3000/chat -l ${ADMIN_USERNAME} -p ${ADMIN_PASS} -s -v $@
}

echo "===[ Rocketchat Configuration ]==="
cat /rocketchatsetting.template.txt | envsubst > /rocketchatsetting.txt
rocketchatsetting $(tr -s '\n' ' ' < /rocketchatsetting.txt)
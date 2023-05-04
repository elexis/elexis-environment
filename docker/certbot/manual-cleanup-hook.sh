#/usr/bin/env sh
if [ -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID ]; then
        RECORD_ID=$(cat /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID)
        rm -f /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID
fi

# Remove the challenge TXT record from the zone
if [ -n "${RECORD_ID}" ]; then
    echo "Cleaning RecordId: ${RECORD_ID}"
    wget -q --header "XRECORDID: ${RECORD_ID}" --header "XRECORDOP: delete" --header "XSHAREDSECRET: ${EE_TOOLS_CERTBOT_SHARED_SECRET}" \
        -O - https://tools.medelexis.ch/CC0DA21C-93D7-4ED4-A842-BEA0C76879B7  
fi
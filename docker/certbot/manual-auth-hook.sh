#/usr/bin/env sh
# used within ee setup create_refresh_cert to satisfy certbot dns challenge
CHALLENGE_RECORD_NAME="_acme-challenge.${CERTBOT_DOMAIN//.myelexis.ch/}"
# exoscale api requires the domain to be removed from the record name
echo "Record-Name: ${CHALLENGE_RECORD_NAME}"

# Create TXT record (via tools.medelexis.ch -> requires shared key to be set)
OUTPUT=$(wget -q --header "XRECORDNAME: ${CHALLENGE_RECORD_NAME}" --header "XRECORDTYPE: txt" --header "XRECORDTTL: 60" \
    --header "XRECORDCONTENT: ${CERTBOT_VALIDATION}" --header "XRECORDOP: post" --header "XSHAREDSECRET: ${EE_TOOLS_CERTBOT_SHARED_SECRET}" \
    -O - https://tools.medelexis.ch/CC0DA21C-93D7-4ED4-A842-BEA0C76879B7)
echo "Response: $OUTPUT"

RECORD_ID=$(echo $OUTPUT | python -c "import sys,json;print(json.load(sys.stdin)['record']['id'])")
echo "Record-Id: $RECORD_ID"
# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi

echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID

WAIT_TIME=30
# Sleep to make sure the change has time to propagate over to DNS
echo "Waiting $WAIT_TIME seconds for DNS TXT entry to propagate..."
sleep $WAIT_TIME
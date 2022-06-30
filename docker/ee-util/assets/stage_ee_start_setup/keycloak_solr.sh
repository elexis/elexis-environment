#!/bin/bash
# SOLR Keycloak Initialization Script
T="$S (solr)"

SOLR_OPENID_CLIENTID=$(getClientId solr | cut -d "," -f1)
if [ -z $SOLR_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    SOLR_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=solr -i)
    echo "ok $SOLR_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$SOLR_OPENID_CLIENTID -r ElexisEnvironment -s enabled=true -s baseUrl=https://$EE_HOSTNAME/solr/ -s bearerOnly=true
createOrUpdateClientRole $SOLR_OPENID_CLIENTID user 'description=Read and query'
createOrUpdateClientRole $SOLR_OPENID_CLIENTID indexer 'description=Allowed to update collections'
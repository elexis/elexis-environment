#!/bin/bash
source keycloak_functions.sh
#
# ELEXIS-SERVER.FHIR-API (Bearer Only)
#
T="$S (elexis-server.fhir-api)"
ES_FHIR_OPENID_CLIENTID=$(getClientId elexis-server.fhir-api | cut -d "," -f1)
if [ -z $ES_FHIR_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ES_FHIR_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-server.fhir-api -i)
    echo "ok $ES_FHIR_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$ES_FHIR_OPENID_CLIENTID -r ElexisEnvironment -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_SERVER_CLIENT_SECRET -s bearerOnly=true

#
# ELEXIS-SERVER.JAXRS-API (Bearer Only)
#
T="$S (elexis-server.jaxrs-api)"
ES_JAXRS_OPENID_CLIENTID=$(getClientId elexis-server.jaxrs-api | cut -d "," -f1)
if [ -z $ES_JAXRS_OPENID_CLIENTID ]; then
    echo -n "$T create client ... "
    ES_JAXRS_OPENID_CLIENTID=$($KCADM create clients -r ElexisEnvironment -s clientId=elexis-server.jaxrs-api -i)
    echo "ok $ES_JAXRS_OPENID_CLIENTID"
fi

echo "$T update client settings ... "
$KCADM update clients/$ES_JAXRS_OPENID_CLIENTID -r ElexisEnvironment -s enabled=true -s clientAuthenticatorType=client-secret -s secret=$X_EE_ELEXIS_SERVER_CLIENT_SECRET -s bearerOnly=true

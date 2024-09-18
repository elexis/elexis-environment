#!/bin/bash
T="[MATRIX] "
echo "$T $(date)"

HOMESERVER_YAML=/site/matrix/synapse/homeserver.yaml
echo "$T Writing $HOMESERVER_YAML"

NAMES="client"
if [ $ENABLE_MATRIX_FEDERATION == "true" ]; then
    NAMES+=", federation"
fi
export NAMES
SYNAPSE_USER_DATABASE_PASSWORD=$(cat /site/matrix/synapse/postgres_password) \
envsubst < matrix/homeserver.yaml.template > $HOMESERVER_YAML
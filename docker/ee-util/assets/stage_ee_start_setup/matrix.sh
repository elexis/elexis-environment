#!/bin/bash
T="[MATRIX] "
echo "$T $(date)"

SYNAPSE_USER_DATABASE_PASSWORD=$(cat /site/matrix/synapse/postgres_password) \
envsubst < matrix/homeserver.yaml.template > /site/matrix/synapse/homeserver.yaml
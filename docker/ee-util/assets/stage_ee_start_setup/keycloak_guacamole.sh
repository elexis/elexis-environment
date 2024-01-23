#!/bin/bash
source keycloak_functions.sh
# Keycloak Guacamole configuration script
T="$S (guacamole)"

# create realm roles
# we do not assign as client role, as client is via oauth2-proxy
createOrUpdateRealmRole guacamole 'description=Benutzer des Guacamole Remote Desktop Client'
createOrUpdateRealmRole guacamole-admin 'description=Administrator des Guacamole Remote Desktop Client'
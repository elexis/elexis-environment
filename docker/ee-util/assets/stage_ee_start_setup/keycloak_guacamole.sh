#!/bin/bash
source keycloak_functions.sh
# Keycloak Guacamole configuration script
T="$S (guacamole)"

# create realm roles
createOrUpdateRealmRole guacamole 'description=Benutzer des Guacamole Remote Desktop Client'
createOrUpdateRealmRole guacamole-admin 'description=Administrator des Guacamole Remote Desktop Client'
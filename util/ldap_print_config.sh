#!/bin/bash
docker exec elexis-environment_ldap_1 ldapsearch  -Y EXTERNAL -H ldapi:/// -b cn=config

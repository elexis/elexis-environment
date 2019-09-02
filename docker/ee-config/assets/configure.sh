#!/bin/bash

#
# TEST PRECONDITIONS
#
echo "=== Testing environment variables"

bats tests.bats
if [ $? -ne 0 ]
then
  echo "Tests showed an error, not performing configuration"
  exit
fi

#
# PERFORM CONFIGURATION
#
echo "=== Preparing configuration files"

if [ ! -f "/assets/web/ssl/dhparam.pem" ]; 
then
    echo "  generating dhparam.pem ... please wait ..."
    openssl dhparam -dsaparam -out /assets/web/ssl/dhparam.pem 4096
else
    echo "  skipping dhparam.pem generation"
fi

if [ ! -f "/assets/web/ssl/myserver.cnf" ]; 
then
echo "   writing ssl configuration file ..."
cat <<EOF >/assets/web/ssl/myserver.cnf
# see https://www.switch.ch/pki/manage/request/csr-openssl/
FQDN=${EE_HOSTNAME}
ORGNAME=${ORGANISATION_NAME}
ALTNAMES = DNS:\$FQDN
[ req ]
default_bits = 2048
default_md = sha256
prompt = no
encrypt_key = no
distinguished_name = dn
req_extensions = req_ext
[ dn ]
C = CH
O = \$ORGNAME
CN = \$FQDN
[ req_ext ]
subjectAltName = \$ALTNAMES
EOF
else
  echo "   skipping myserver.cnf generation"
fi

if [ ! -f "/assets/web/ssl/myserver.key" ]; 
then
    echo "   generating myserver.key/csr"
    openssl req -new -config /assets/web/ssl/myserver.cnf -keyout /assets/web/ssl/myserver.key -out /assets/web/ssl/myserver.csr
else
    echo "   skipping myserver.key/csr generation"
fi

if [ ! -f "/assets/ldap/bootstrap.ldif" ]; 
then
    echo "   generating bootstrap.ldif"
    SALT="$(openssl rand 3)"
    SHA1="$(printf "%s%s" "$ADMIN_PASS" "$SALT" | openssl dgst -binary -sha1)"
    SHA1_ADMIN_PASS="$(printf "%s%s" "$SHA1" "$SALT" | base64)"
    export SHA1_ADMIN_PASS
    cat /assets/ldap/bootstrap.ldif.template | envsubst > /assets/ldap/bootstrap.ldif
else
    echo "   skipping bootstrap.ldif generation"
fi

echo "   generating nginx.conf"
cat /assets/web/etc/nginx.conf.template | envsubst | sed -e 's/§/$/g' > /assets/web/etc/nginx.conf
#!/bin/sh

# we need to import a self-signed s3 certificate
if [ "$OBJECTSTORE_S3_SSL" = "true" ]; then
    echo "$(date): Assert S3 objectstore HTTPS certificate"
    echo "" | openssl s_client -showcerts -connect $OBJECTSTORE_S3_HOST:$OBJECTSTORE_S3_PORT | openssl x509 -outform PEM > /usr/local/share/ca-certificates/ca-root-nss.crt
    update-ca-certificates
fi



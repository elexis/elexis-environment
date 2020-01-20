FROM nextcloud:18-fpm-alpine

RUN apk add --no-cache procps samba-client
COPY assets/ee-init.sh /
COPY assets/entrypoint.sh /

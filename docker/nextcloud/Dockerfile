FROM nextcloud:17-fpm-alpine
ENV  WEBHOOK_VERSION 2.6.11

RUN apk add --no-cache procps samba-client
COPY assets/entrypoint.sh /
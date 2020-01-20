FROM nextcloud:18-fpm-alpine

RUN apk add --no-cache procps samba-client
# https://www.reddit.com/r/NextCloud/comments/9e5ljv/nextcloud_and_phpfpm_adjustments/
RUN sed -i -e 's/^pm\ =\ dynamic/pm\ =\ static/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^pm.max_children\ =\ 5/pm.max_children\ =\ 64/' /usr/local/etc/php-fpm.d/www.conf
COPY assets/ee-init.sh /
COPY assets/entrypoint.sh /

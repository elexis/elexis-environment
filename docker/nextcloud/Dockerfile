FROM nextcloud:28-fpm-alpine

RUN apk add --no-cache jq bash
# https://www.reddit.com/r/NextCloud/comments/9e5ljv/nextcloud_and_phpfpm_adjustments/
RUN sed -i -e 's/^pm\ =\ dynamic/pm\ =\ static/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^pm.max_children\ =\ 5/pm.max_children\ =\ 64/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^listen\ =\ 9000/listen\ =\ \/var\/run\/php-fpm-sock\/php-fpm.sock/' /usr/local/etc/php-fpm.d/zz-docker.conf && \
    echo "listen.mode = 0666" >> /usr/local/etc/php-fpm.d/zz-docker.conf
COPY assets/ee-pre-init.sh /
COPY assets/ee-init.sh /
COPY assets/entrypoint.sh /
COPY assets/groupfolders.csv /

COPY --chown=www-data:root assets/apps/acom_custom_js_css/ /var/www/acom_custom_js_css
COPY --chown=www-data:root assets/core/img/logo/logo.svg /var/www/core/img/logo/logo.svg
COPY --chown=www-data:root assets/core/img/logo/logo.png /var/www/core/img/logo/logo.png
COPY --chown=www-data:root assets/core/doc/user/_static/custom.css /var/www/core/doc/user/_static/custom.css
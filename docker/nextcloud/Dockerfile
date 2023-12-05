FROM nextcloud:26.0.0-fpm-alpine

RUN apk add --no-cache procps libsmbclient imagemagick
# https://www.reddit.com/r/NextCloud/comments/9e5ljv/nextcloud_and_phpfpm_adjustments/
RUN sed -i -e 's/^pm\ =\ dynamic/pm\ =\ static/' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i -e 's/^pm.max_children\ =\ 5/pm.max_children\ =\ 64/' /usr/local/etc/php-fpm.d/www.conf

COPY assets/ee-init.sh /
COPY assets/entrypoint.sh /

COPY assets/smb/smbclient.so /usr/local/lib/php/extensions/no-debug-non-zts-20210902/smbclient.so
COPY assets/smb/docker-php-ext-smbclient.ini /usr/local/etc/php/conf.d/docker-php-ext-smbclient.ini
# App
COPY --chown=www-data:root assets/apps/acom_custom_js_css/ /var/www/acom_custom_js_css
# Logo svg
COPY --chown=www-data:root assets/core/img/logo/logo.svg /var/www/core/img/logo/logo.svg
# Logo png
COPY --chown=www-data:root assets/core/img/logo/logo.png /var/www/core/img/logo/logo.png
# Custom css
COPY --chown=www-data:root assets/core/doc/user/_static/custom.css /var/www/core/doc/user/_static/custom.css

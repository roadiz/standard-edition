FROM roadiz/php73-nginx-alpine:latest
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>
ENV USER_UID=1000
ARG USER_UID=1000
ENV ROADIZ_ENV=prod

COPY . /var/www/html/
COPY samples/index.php.docker /var/www/html/web/index.php
COPY samples/preview.php.docker /var/www/html/web/preview.php
COPY samples/clear_cache.php.sample /var/www/html/web/clear_cache.php
VOLUME /var/www/html/files /var/www/html/web/files /var/www/html/app/logs /var/www/html/app/conf /var/www/html/app/gen-src/GeneratedNodeSources /var/www/html/app/gen-src/Proxies 

RUN apk add --no-cache shadow make \
    && usermod -u ${USER_UID} www-data \
    && chown -R www-data:www-data /var/www/html/

ENTRYPOINT exec /usr/bin/supervisord -n -c /etc/supervisord.conf

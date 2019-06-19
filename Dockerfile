FROM roadiz/php73-nginx-alpine:latest
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>
ENV USER_UID=1000
ARG USER_UID=1000
ENV ROADIZ_ENV=prod

RUN apk add --no-cache shadow make \
    && usermod -u ${USER_UID} www-data \
    && groupmod -g ${USER_UID} www-data

COPY --chown=www-data:www-data . /var/www/html/
COPY --chown=www-data:www-data samples/index.php.docker /var/www/html/web/index.php
COPY --chown=www-data:www-data samples/preview.php.docker /var/www/html/web/preview.php
COPY --chown=www-data:www-data samples/clear_cache.php.sample /var/www/html/web/clear_cache.php

VOLUME /var/www/html/files \
       /var/www/html/web/files \
       /var/www/html/app/logs  \
       /var/www/html/app/conf \
       /var/www/html/app/gen-src/GeneratedNodeSources \
       /var/www/html/app/gen-src/Proxies \
       /var/www/html/app/gen-src/Compiled

ENTRYPOINT exec /usr/bin/supervisord -n -c /etc/supervisord.conf

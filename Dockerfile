FROM roadiz/php80-nginx-alpine:latest
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>
ARG USER_UID=1000
ENV APP_ENV=prod
ENV APP_DEBUG=0

RUN usermod -u ${USER_UID} www-data \
    && groupmod -g ${USER_UID} www-data

COPY docker/php-nginx-alpine/crontab.txt /crontab.txt
COPY docker/php-nginx-alpine/before_launch.sh /before_launch.sh
COPY --chown=www-data:www-data . /var/www/html/
COPY --chown=www-data:www-data samples/index.php.sample /var/www/html/web/index.php
COPY --chown=www-data:www-data samples/preview.php.sample /var/www/html/web/preview.php
COPY --chown=www-data:www-data samples/clear_cache.php.sample /var/www/html/web/clear_cache.php
#
# Copy default config and dotenv to be able to configure Roadiz from env vars only.
#
COPY --chown=www-data:www-data .env.dist /var/www/html/.env
COPY --chown=www-data:www-data app/conf/config.default.yml /var/www/html/app/conf/config.yml

RUN /usr/bin/crontab -u www-data /crontab.txt \
    && chmod +x /before_launch.sh

VOLUME /var/www/html/files \
       /var/www/html/web/files \
       /var/www/html/web/assets \
       /var/www/html/app/logs  \
       /var/www/html/app/conf \
       /var/www/html/app/gen-src/GeneratedNodeSources \
       /var/www/html/app/gen-src/Proxies \
       /var/www/html/app/gen-src/Compiled

ENTRYPOINT exec /usr/bin/supervisord -n -c /etc/supervisord.conf

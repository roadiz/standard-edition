# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM roadiz/php80-nginx-alpine
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>

ARG USER_UID=1000
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APP_ENV=dev
ENV APP_CACHE=0

RUN apk add --no-cache git openssh \
    && echo "USER_UID: ${USER_UID}\n" \
    && usermod -u ${USER_UID} www-data \
    && groupmod -g ${USER_UID} www-data \
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/alpine/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
    && composer --version \
    && ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime \
    && "date"

# Display errors
ADD php.ini /usr/local/etc/php/php.ini
ADD zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
ADD crontab.txt /crontab.txt
ADD before_launch.sh /before_launch.sh

VOLUME /var/www/html
WORKDIR /var/www/html

RUN ln -s /usr/share/nginx/html/bin/roadiz /usr/local/bin/roadiz \
    && /usr/bin/crontab -u www-data /crontab.txt \
    && chmod +x /before_launch.sh \
    && chown -R www-data:www-data /var/www/html/

ENTRYPOINT exec /usr/bin/supervisord -n -c /etc/supervisord.conf

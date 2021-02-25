FROM roadiz/php74-apache:latest
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>

ARG USER_UID=1000
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV APP_ENV=dev
ENV APP_CACHE=0

# Display errors
ADD php.ini /usr/local/etc/php/php.ini
ADD default.conf /etc/apache2/sites-enabled/000-default.conf

VOLUME /var/www/html
WORKDIR /var/www/html

RUN echo "USER_UID: ${USER_UID}\n" \
    && a2enmod headers expires rewrite \
    && usermod -u ${USER_UID} www-data \
    && groupmod -g ${USER_UID} www-data \
    && version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
    && composer --version \
    && chown -R www-data:www-data /var/www/html/

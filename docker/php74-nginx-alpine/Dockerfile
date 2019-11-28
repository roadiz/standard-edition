# See https://github.com/docker-library/php/blob/4677ca134fe48d20c820a19becb99198824d78e3/7.0/fpm/Dockerfile
FROM roadiz/php74-nginx-alpine
MAINTAINER Ambroise Maupate <ambroise@rezo-zero.com>

ENV USER_UID=1000
ARG USER_UID=1000
ENV COMPOSER_ALLOW_SUPERUSER=1
ENV ROADIZ_ENV=dev

# Install Composer
# And use local user as www-data
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    composer --version && \
    ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
    "date"

# install xdebug
RUN apk add --no-cache --virtual .build-deps $PHPIZE_DEPS git gcc g++ make autoconf shadow \
    && mkdir /src && cd /src && git clone https://github.com/xdebug/xdebug.git \
    && cd xdebug \
    && sh ./rebuild.sh \
    && echo "[xdebug]" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.remote_port=9000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    # && echo "xdebug.remote_connect_back=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && cd  / && rm -fr /src \
    && apk del .build-deps $PHPIZE_DEPS git gcc g++ autoconf \
    && rm -rf /tmp/*

RUN echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "display_errors = On" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "html_errors = On" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "realpath_cache_size=4096K" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    echo "realpath_cache_ttl=600" >> /usr/local/etc/php/conf.d/zz-docker-php-dev.ini && \
    # echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # echo "xdebug.idekey=\"PHPSTORM\"" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    # echo "xdebug.remote_port=9001" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "apc.enabled=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini && \
    echo "opcache.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.memory_consumption=128" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.interned_strings_buffer=8" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.max_accelerated_files=20000" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.revalidate_freq=0" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini && \
    echo "opcache.fast_shutdown=1" >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Display errors
ADD php.ini /usr/local/etc/php/php.ini
ADD zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf

VOLUME /var/www/html
WORKDIR /var/www/html

RUN ln -s /usr/share/nginx/html/bin/roadiz /usr/local/bin/roadiz \
    && usermod -u ${USER_UID} www-data \
    && chown -R www-data:www-data /var/www/html/

ENTRYPOINT exec /usr/bin/supervisord -n -c /etc/supervisord.conf

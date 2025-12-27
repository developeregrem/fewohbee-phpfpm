# docker-compose build
FROM php:8.5-fpm-alpine

ENV FEWOHBEE_VERSION=latest

ARG PHP_EXTS="redis intl gd pdo_mysql"

ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN apk add --update --no-cache \
        git \
        zip \
        unzip \
        tzdata \
        icu \
        # required for full langugae support: https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.16.0#ICU_data_split
        icu-data-full 

RUN install-php-extensions ${PHP_EXTS}

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]

# docker-compose build
FROM php:8.3-fpm-alpine

ENV PHPREDIS_VERSION 5.3.7
ENV FEWOHBEE_VERSION latest

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts 
    
RUN apk add --update --no-cache \
        git \
        zip \
        unzip \
        tzdata \
	freetype \
        libjpeg-turbo \
        libpng \
        libxml2 \
        icu \
        # required for full langugae support: https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.16.0#ICU_data_split
        icu-data-full 

RUN apk add --no-cache --virtual .build-deps \
        autoconf \
        freetype-dev \
        libjpeg-turbo-dev \
		libpng-dev \
        libxml2-dev \
        icu-dev \
        pcre-dev \
    && docker-php-ext-configure gd --with-freetype=/usr/include/ --with-jpeg=/usr/include/ \
	&& docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install intl pdo_mysql xml opcache redis \
    && apk del .build-deps

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9000
CMD ["php-fpm"]

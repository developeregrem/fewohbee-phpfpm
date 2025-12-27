

# fewohbee-phpfpm

This Docker image is based on [PHP 8.5-fpm-alpine](https://hub.docker.com/_/php/), [phpredis](https://github.com/phpredis/phpredis) and latest [composer](https://hub.docker.com/_/composer).
This image is optimized for the [guesthouse administration](https://github.com/developeregrem/fewohbee) tool (Pensionsverwaltung). See [FewohBee's website](https://www.fewohbee.de)
When running this image it will clone the latest stable release of the tool and installs all required PHP/Symfony dependencies.

## supported tags
 - `:latest` - always pull the latest image

## Supported architectures  
[`amd64`](https://hub.docker.com/r/amd64/php/), [`arm64v8`](https://hub.docker.com/r/arm64v8/php/)
		
## Volume structure

 - `/var/www` - web accessible resources (php files)
 - `/usr/local/etc/php` - custom php config file (see example [conf.ini](https://github.com/developeregrem/fewohbee-dockerized/blob/master/conf/php/conf.ini))

## Environment variables

### PHP
 - `TZ` - time zone e.g. "Europe/Berlin"

### guesthouse administration (fewohbee, symfony specific)

- LOCALE - language of the application (e.g. de, en)
- FEWOHBEE_VERSION - which version of fewohbee shall be used (default: latest)
- APP_ENV - environment (prod|dev)
- APP_SECRET - random secret
- DATABASE_URL - db schema url
- MAILER_DSN - mailer schema url
- FROM_MAIL - mail address
- FROM_NAME - name (e.g. "Pension XY)
- RETURN_PATH - return mail address (mostly the same like from_mail)
- DB_SERVER_VERSION - specify the version of your database (e.g. mariadb-10.5.9)
- REDIS_HOST - host of the redis server for caching
- REDIS_IDX - which redis index is used
- WEB_HOST - host from where images for PDF files shall be loaded
 
## Example usage

This image is part of the [fewohbee-dockerized](https://github.com/developeregrem/fewohbee-dockerized) docker-compose setup. A docker-compose file can be found here:

- https://github.com/developeregrem/fewohbee-dockerized



# fewohbee-phpfpm

This Docker image is based on [PHP 7.4-fpm-alpine](https://hub.docker.com/_/php/), [phpredis](https://github.com/phpredis/phpredis) and latest [composer](https://hub.docker.com/_/composer).
This image is optimized for the [guesthouse administration](https://github.com/developeregrem/fewohbee) tool (Pensionsverwaltung). See [FewohBee's website](https://www.fewohbee.de)
When running this image it will clone the latest stable release of the tool and installs all required PHP/Symfony dependencies.

## supported tags

 - `:latest` - latest build

## Supported architectures  
[`amd64`](https://hub.docker.com/r/amd64/php/),  [`arm32v7`](https://hub.docker.com/r/arm32v7/php/), [`arm64v8`](https://hub.docker.com/r/arm64v8/php/)
		
## Volume structure

 - `/var/www` - web accessible resources (php files)
 - `/usr/local/etc/php` - custom php config file (see example [conf.ini](https://github.com/developeregrem/fewohbee-dockerized/blob/master/conf/php/conf.ini))

## Environment variables

### PHP
 - `TZ` - time zone e.g. "Europe/Berlin"

### guesthouse administration (fewohbee, symfony specific)

- LOCALE - language of the application (e.g. de)
- APP_ENV - environment (prod|dev)
- APP_SECRET - random secret
- DATABASE_URL - db schema url
- MAILER_URL - mailer schema url
- FROM_MAIL - mail address
- FROM_NAME - name (e.g. "Pension XY)
- RETURN_PATH - return mail address (mostly the same like from_mail)
- MAIL_HOST - mail domain (e.g. domain.tld)
 
## Example usage

This image is part of the [fewohbee-dockerized](https://github.com/developeregrem/fewohbee-dockerized) docker-compose setup. A docker-compose file can be found here:

- https://github.com/developeregrem/fewohbee-dockerized

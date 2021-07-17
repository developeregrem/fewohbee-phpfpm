#!/bin/sh
if [ ! -f "/firstrun" ]; then
    echo "0" > /firstrun
    pveFolder=/var/www/html/fewohbee
    if [ ! -d "$pveFolder" ]; then
        git clone https://github.com/developeregrem/fewohbee.git $pveFolder
        cd $pveFolder
        composer install
    else
        cd $pveFolder
        git fetch --tags
    fi
    
    if [ "$FEWOHBEE_VERSION" == "latest" ]
    then
        latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    else
        latestTag="$FEWOHBEE_VERSION"
    fi
    
    git checkout -f $latestTag
    
    if [ "$APP_ENV" == "prod" ] || [ "$APP_ENV" == "redis" ]
    then
        composer update --no-dev --optimize-autoloader
    else
        composer update
    fi
    # make sure that user www-data from php and web container can access files
    chown -R 82:33 $pveFolder
    
    su -p www-data -s /bin/sh -c "php bin/console --no-interaction doctrine:migration:migrate"

    # clear doctrine cache
    su -p www-data -s /bin/sh -c "php bin/console cache:pool:clear doctrine.result_cache_pool doctrine.system_cache_pool"
fi
echo "1" > /firstrun

set -e
# copied from the original php entrypoint.sh file
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"

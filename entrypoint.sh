#!/bin/sh
if [ ! -f "/firstrun" ]; then
    echo "0" > /firstrun
    pveFolder=/var/www/html/fewohbee
    # this is required due to new security restrictions in git >= 2.35.2 because the ownership of fewohbee folder will be changed to www-data during the setup
    git config --global --add safe.directory $pveFolder
    
    if [ ! -d "$pveFolder" ]; then
        git clone https://github.com/developeregrem/fewohbee.git $pveFolder
        cd $pveFolder
    else
        cd $pveFolder
        git fetch --tags --force
        rm -rf var/cache
    fi
    
    if [ "$FEWOHBEE_VERSION" == "latest" ]
    then
        latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    else
        latestTag="$FEWOHBEE_VERSION"
    fi
    
    git checkout -f $latestTag
    
    appDebug="APP_DEBUG=0"
    if [ "$APP_ENV" == "prod" ] || [ "$APP_ENV" == "redis" ]
    then
        composer install --no-dev --no-interaction --optimize-autoloader
    else
        composer --no-interaction install
        appDebug="APP_DEBUG=1"
    fi
    # make sure that user www-data from php and web container can access files
    chown -R 82:33 $pveFolder
    
    su -p www-data -s /bin/sh -c "php bin/console --no-interaction doctrine:migration:migrate"

    # clear doctrine cache
    su -p www-data -s /bin/sh -c "php bin/console cache:pool:clear doctrine.result_cache_pool doctrine.system_cache_pool"

    # compile assets
    su -p www-data -s /bin/sh -c "$appDebug php bin/console asset-map:compile"
fi
echo "1" > /firstrun

set -e
# copied from the original php entrypoint.sh file
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"

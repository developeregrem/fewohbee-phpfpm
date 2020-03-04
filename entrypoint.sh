#!/bin/sh
if [ ! -f "/firstrun" ]; then
    
    pveFolder=/var/www/html/pve
    if [ ! -d "$pveFolder" ]; then
        git clone https://github.com/developeregrem/pve.git $pveFolder
        cd $pveFolder
        composer install
    else
        cd $pveFolder
        git fetch --tags
    fi
    
    latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
    git checkout -f $latestTag
    
    composer update --no-dev --optimize-autoloader
    # make sure that user www-data from php and web container can access files
    chown -R 82:33 $pveFolder
    
    su -p www-data -s /bin/sh -c "php bin/console --no-interaction doctrine:migration:migrate"
fi
echo "1" > /firstrun

set -e
# copied from the original php entrypoint.sh file
# first arg is `-f` or `--some-option`
if [ "${1#-}" != "$1" ]; then
	set -- php-fpm "$@"
fi

exec "$@"

#######################################################################################################################
# START: bash initialization

set -e
set -u
set -o pipefail

# STOP: bash initialization
#######################################################################################################################

#######################################################################################################################
# START: shared utils

check_variable() {
    read -p "${1}=${2} - Please type 'YES' to continue: " user_input;
    [ "$user_input" == "YES" ] || { echo "You did not type 'YES'. Exiting."; exit 1; }
}

# STOP: shared utils
#######################################################################################################################

#######################################################################################################################
# START: shared

ROOT_DATA=/home/large/tuks
check_variable ROOT_DATA ${ROOT_DATA}

DOMAIN=zaqqaz.cz
check_variable DOMAIN ${DOMAIN}

# STOP: shared
#######################################################################################################################

#######################################################################################################################
# START: caddy

export CADDY_VOLUME_CONFIG=${ROOT_DATA}/caddy/config
export CADDY_VOLUME_DATA=${ROOT_DATA}/caddy/data

cp services/caddy/Caddyfile.template services/caddy/Caddyfile

# STOP: caddy
#######################################################################################################################

#######################################################################################################################
# START: jellyfin

export JELLYFIN_DOMAIN=media.${DOMAIN}
sed -i "s/JELLYFIN_DOMAIN/${JELLYFIN_DOMAIN}/" services/caddy/Caddyfile

export JELLYFIN_VOLUME_CONFIG=${ROOT_DATA}/jellyfin/config
export JELLYFIN_VOLUME_CACHE=${ROOT_DATA}/jellyfin/cache
export JELLYFIN_VOLUME_MEDIA=${ROOT_DATA}/jellyfin/media

# STOP: jellyfin
#######################################################################################################################

#######################################################################################################################
# START: freshrss

export FRESHRSS_DOMAIN=rss.${DOMAIN}
sed -i "s/FRESHRSS_DOMAIN/${FRESHRSS_DOMAIN}/" services/caddy/Caddyfile

export FRESHRSS_TZ=Europe/Prague
export FRESHRSS_CRON_MIN=9,39
export FRESHRSS_VOLUME=${ROOT_DATA}/freshrss/data

# STOP: freshrss
#######################################################################################################################

#######################################################################################################################
# START: transmission

export TRANSMISSION_DOMAIN=transmission.${DOMAIN}
sed -i "s/TRANSMISSION_DOMAIN/${TRANSMISSION_DOMAIN}/" services/caddy/Caddyfile

export TRANSMISSION_PUID=1000
export TRANSMISSION_PGID=1000
export TRANSMISSION_TZ=Europe/Prague
export TRANSMISSION_WEB_USER=transmission
export TRANSMISSION_WEB_PASS=HesloTransmission

export TRANSMISSION_VOLUME_CONFIG=${ROOT_DATA}/transmission/config
export TRANSMISSION_VOLUME_DOWNLOADS=${ROOT_DATA}/transmission/downloads
export TRANSMISSION_VOLUME_WATCH=${ROOT_DATA}/transmission/watch

# STOP: transmission
#######################################################################################################################

#######################################################################################################################
# START: leila wordpress

export LEILA_WORDPRESS_DOMAIN=leila.${DOMAIN}
sed -i "s/LEILA_WORDPRESS_DOMAIN/${LEILA_WORDPRESS_DOMAIN}/" services/caddy/Caddyfile

export LEILA_WORDPRESS_MYSQL_ROOT_PASSWORD=somewordpress
export LEILA_WORDPRESS_MYSQL_DATABASE=wordpress
export LEILA_WORDPRESS_MYSQL_USER=wordpress
export LEILA_WORDPRESS_MYSQL_PASSWORD=wordpress

export LEILA_WORDPRESS_VOLUME_DATA=${ROOT_DATA}/leila_wordpress/wordpress
export LEILA_WORDPRESS_VOLUME_DB=${ROOT_DATA}/leila_wordpress/database

# STOP: leila wordpress
#######################################################################################################################

#######################################################################################################################
# START: firefly

export FIREFLY_DOMAIN=fire.${DOMAIN}
sed -i "s/FIREFLY_DOMAIN/${FIREFLY_DOMAIN}/" services/caddy/Caddyfile

export FIREFLY_IMPORTER_DOMAIN=fire-imp.${DOMAIN}
sed -i "s/FIREFLY_IMPORTER_DOMAIN/${FIREFLY_IMPORTER_DOMAIN}/" services/caddy/Caddyfile

export FIRELY_MYSQL_ROOT_PASSWORD=538gfdhe12343f.14
export FIRELY_MYSQL_DATABASE=firefly
export FIRELY_MYSQL_USER=firefly
export FIRELY_MYSQL_PASSWORD=1244tg2.31234sd

export FIREFLY_APP_KEY=So3eRae6om5tri7gOf33Chgrs1xa5bly

export FIRELY_VOLUME_UPLOAD=${ROOT_DATA}/firefly/upload
export FIRELY_VOLUME_DB=${ROOT_DATA}/firefly/database

# STOP: firefly
#######################################################################################################################

#######################################################################################################################
# START: docker compose up -d

docker compose -f services/caddy/docker-compose.yaml up -d --force-recreate
docker compose -f services/jellyfin/docker-compose.yaml up -d --force-recreate
docker compose -f services/freshrss/docker-compose.yaml up -d --force-recreate
docker compose -f services/transmission/docker-compose.yaml up -d --force-recreate
docker compose -f services/leila_wordpress/docker-compose.yaml up -d --force-recreate
docker compose -f services/firefly/docker-compose.yaml up -d --force-recreate

# STOP: docker compose up -d
#######################################################################################################################

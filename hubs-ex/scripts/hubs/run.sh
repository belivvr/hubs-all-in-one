#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

sh ../check_cert_expiration.sh
sh ../initialize_hostnames.sh

cd $WORKDIR/hubs

mkdir -p certs
cp $SSL_CERT_FILE ./certs/cert.pem
cp $SSL_KEY_FILE ./certs/key.pem

# Domain for short links
# export SHORTLINK_DOMAIN="$DOMAIN"
# The thumbnailing backend to connect to.
# See here for the server code: https://github.com/MozillaReality/farspark or https://github.com/MozillaReality/nearspark
# export THUMBNAIL_SERVER="$DOMAIN"
# export ASSET_BUNDLE_SERVER="https://$DOMAIN"

export HOST="$DOMAIN"
export RETICULUM_SOCKET_SERVER="$DOMAIN"
export CORS_PROXY_SERVER="$PROXY:4080"
export NON_CORS_PROXY_DOMAINS="$PROXY,$DOMAIN"
export BASE_ASSETS_PATH="https://$DOMAIN:8080/"
export RETICULUM_SERVER="$DOMAIN:4000"
# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다.
# export POSTGREST_SERVER="https://$DOMAIN:3000"
export POSTGREST_SERVER=""
export ITA_SERVER=""
export UPLOADS_HOST="https://$DOMAIN:4000"
export INTERNAL_HOSTNAME="$DOMAIN"
export HOST_IP="0.0.0.0"

npm run dev

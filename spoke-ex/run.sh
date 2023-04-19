#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f spoke
docker run -d --name spoke \
-v $SSL_CERT_FILE:/app/spoke/certs/cert.pem \
-v $SSL_KEY_FILE:/app/spoke/certs/key.pem \
-w /app/spoke \
-p 9090:9090 \
-e RETICULUM_SERVER="$HUBS_HOST:4000" \
-e HUBS_SERVER="$HUBS_HOST:4000" \
-e ROUTER_BASE_PATH="/spoke" \
-e NODE_TLS_REJECT_UNAUTHORIZED=0 \
-e BASE_ASSETS_PATH="https://$HUBS_HOST:9090/" \
-e CORS_PROXY_SERVER="$PROXY_HOST:4080" \
-e NON_CORS_PROXY_DOMAINS="$PROXY_HOST,$HUBS_HOST" \
-e INTERNAL_HOSTNAME="$HUBS_HOST" \
-e THUMBNAIL_SERVER="$THUMBNAIL_HOST" \
spoke sh -c "yarn start"

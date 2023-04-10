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
-e RETICULUM_SERVER="$DOMAIN:4000" \
-e HUBS_SERVER="$DOMAIN:4000" \
-e ROUTER_BASE_PATH="/spoke" \
-e NODE_TLS_REJECT_UNAUTHORIZED=0 \
-e BASE_ASSETS_PATH="https://$DOMAIN:9090/" \
-e CORS_PROXY_SERVER="$PROXY:4080" \
-e NON_CORS_PROXY_DOMAINS="$PROXY,$DOMAIN" \
-e INTERNAL_HOSTNAME="$DOMAIN" \
spoke sh -c "yarn start"

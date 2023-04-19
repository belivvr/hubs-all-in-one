#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR


# Domain for short links
# export SHORTLINK_DOMAIN="$HUBS_HOST"
# export ASSET_BUNDLE_SERVER="https://$HUBS_HOST"
# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다. 하지마라
# export POSTGREST_SERVER="https://$HUBS_HOST:3000"
# 그렇다고 이거 삭제하면 기본값(hubs.local)으로 접속한다. 삭제도 하지마라

docker rm -f client

docker run -d --name client \
-v $SSL_CERT_FILE:/app/hubs/certs/cert.pem \
-v $SSL_KEY_FILE:/app/hubs/certs/key.pem \
-w /app/hubs \
-p 8080:8080 \
-e HOST="$HUBS_HOST" \
-e RETICULUM_SOCKET_SERVER="$HUBS_HOST" \
-e CORS_PROXY_SERVER="$PROXY_HOST:4080" \
-e NON_CORS_PROXY_DOMAINS="$PROXY_HOST,$HUBS_HOST" \
-e BASE_ASSETS_PATH="https://$HUBS_HOST:8080/" \
-e RETICULUM_SERVER="$HUBS_HOST:4000" \
-e POSTGREST_SERVER="" \
-e ITA_SERVER="" \
-e UPLOADS_HOST="https://$HUBS_HOST:4000" \
-e INTERNAL_HOSTNAME="$HUBS_HOST" \
-e HOST_IP="0.0.0.0" \
-e THUMBNAIL_SERVER="$THUMBNAIL_HOST" \
hubs sh -c "npm run dev"

docker logs client

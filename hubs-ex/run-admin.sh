#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR


# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다. 하지마라
# export POSTGREST_SERVER="https://$DOMAIN:3000"
# 그렇다고 이거 삭제하면 기본값(hubs.local)으로 접속한다. 삭제도 하지마라

# 이건 안 하는거다.
# export UPLOADS_HOST="$DOMAIN:4000"
# CONFIGURABLE_SERVICES: 'janus-gateway,reticulum,hubs,spoke'

docker rm -f hubs-admin

docker run -d --name hubs-admin \
-v $SSL_CERT_FILE:/app/hubs/admin/certs/cert.pem \
-v $SSL_KEY_FILE:/app/hubs/admin/certs/key.pem \
-w /app/hubs/admin \
-p 8989:8989 \
-e RETICULUM_SOCKET_SERVER="$HUBS_HOST" \
-e CORS_PROXY_SERVER="$PROXY_HOST:4080" \
-e NON_CORS_PROXY_DOMAINS="$SPOKE_HOST,$DIALOG_HOST,$POSTGREST_HOST,$DB_HOST,$PROXY_HOST,$HUBS_HOST,$THUMBNAIL_HOST,$ADMIN_HOST,$CLIENT_HOST" \
-e BASE_ASSETS_PATH="https://$ADMIN_HOST:8989/" \
-e RETICULUM_SERVER="$HUBS_HOST:4000" \
-e POSTGREST_SERVER="" \
-e ITA_SERVER="" \
-e INTERNAL_HOSTNAME="$HUBS_HOST" \
-e HOST_IP="0.0.0.0" \
hubs sh -c "npm run dev"

docker logs hubs-admin

# -e HOST="$ADMIN_HOST" \

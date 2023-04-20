#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f admin

docker run -d --name admin \
-v $SSL_CERT_FILE:/etc/nginx/certs/cert.pem \
-v $SSL_KEY_FILE:/etc/nginx/certs/key.pem \
-v $(pwd)/nginx.conf.admin:/etc/nginx/nginx.conf \
-p 8989:8989 \
admin
# -e HOST="$HUBS_HOST" \
# -e RETICULUM_SOCKET_SERVER="$HUBS_HOST" \
# -e CORS_PROXY_SERVER="$PROXY_HOST:4080" \
# -e NON_CORS_PROXY_DOMAINS="$PROXY_HOST,$HUBS_HOST,$POSTGREST_HOST" \
# -e BASE_ASSETS_PATH="https://$HUBS_HOST:8989/" \
# -e RETICULUM_SERVER="$HUBS_HOST:4000" \
# -e POSTGREST_SERVER="" \
# -e ITA_SERVER="" \
# -e INTERNAL_HOSTNAME="$HUBS_HOST" \
# -e HOST_IP="0.0.0.0" \
# -e NODE_ENV="production" \

docker logs admin
# COPY ./nginx.conf.admin /etc/nginx/nginx.conf

# -w /app/hubs/admin \

# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다. 하지마라
# export POSTGREST_SERVER="https://$HUBS_HOST:3000"
# 그렇다고 이거 삭제하면 기본값(hubs.local)으로 접속한다. 삭제도 하지마라

# 이건 안 하는거다.
# export UPLOADS_HOST="$HUBS_HOST:4000"
# CONFIGURABLE_SERVICES: 'janus-gateway,reticulum,hubs,spoke'

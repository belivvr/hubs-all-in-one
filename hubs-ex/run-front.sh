#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd "$(dirname "$0")"

# Domain for short links
# export SHORTLINK_DOMAIN="$DOMAIN"
# The thumbnailing backend to connect to.
# See here for the server code: https://github.com/MozillaReality/farspark or https://github.com/MozillaReality/nearspark
# export THUMBNAIL_SERVER="$DOMAIN"
# export ASSET_BUNDLE_SERVER="https://$DOMAIN"

# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다.
# export POSTGREST_SERVER="https://$DOMAIN:3000"

# export HOST="$DOMAIN"
# export RETICULUM_SOCKET_SERVER="$DOMAIN"
# export CORS_PROXY_SERVER="$PROXY:4080"
# export NON_CORS_PROXY_DOMAINS="$PROXY,$DOMAIN"
# export BASE_ASSETS_PATH="https://$DOMAIN:8080/"
# export RETICULUM_SERVER="$DOMAIN:4000"
# export POSTGREST_SERVER=""
# export ITA_SERVER=""
# export UPLOADS_HOST="https://$DOMAIN:4000"
# export INTERNAL_HOSTNAME="$DOMAIN"
# export HOST_IP="0.0.0.0"

docker rm -f hubs-front

docker run -d --name hubs-front \
-v $SSL_CERT_FILE:/app/hubs/certs/cert.pem \
-v $SSL_KEY_FILE:/app/hubs/certs/key.pem \
-w /app/hubs \
-p 8080:8080 \
-e HOST="$DOMAIN" \
-e RETICULUM_SOCKET_SERVER="$DOMAIN" \
-e CORS_PROXY_SERVER="$PROXY:4080" \
-e NON_CORS_PROXY_DOMAINS="$PROXY,$DOMAIN" \
-e BASE_ASSETS_PATH="https://$DOMAIN:8080/" \
-e RETICULUM_SERVER="$DOMAIN:4000" \
-e POSTGREST_SERVER="" \
-e ITA_SERVER="" \
-e UPLOADS_HOST="https://$DOMAIN:4000" \
-e INTERNAL_HOSTNAME="$DOMAIN" \
-e HOST_IP="0.0.0.0" \
hubs sh -c "npm run dev"

docker logs hubs-front

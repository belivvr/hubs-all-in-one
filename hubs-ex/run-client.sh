#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

cp nginx.client.template nginx.conf.client
replace_vars_in_files "nginx.conf.client"

docker rm -f client

docker run -d --name client \
-v $SSL_CERT_FILE:/etc/nginx/certs/cert.pem \
-v $SSL_KEY_FILE:/etc/nginx/certs/key.pem \
-v $(pwd)/nginx.conf.client:/etc/nginx/nginx.conf \
-p 8080:8080 \
client

# 순수하게 프론트소스만 있다. 런타임에 환경설정 안 된다.
# 빌드 타임에 설정해야 한다.

docker logs client

# -w /app/hubs \

# Domain for short links
# export SHORTLINK_DOMAIN="$HUBS_HOST"
# export ASSET_BUNDLE_SERVER="https://$HUBS_HOST"
# 이거 설정하면 POSTGREST_SERVER로 바로 붙는다. 하지마라
# export POSTGREST_SERVER="https://$HUBS_HOST:3000"
# 그렇다고 이거 삭제하면 기본값(hubs.local)으로 접속한다. 삭제도 하지마라

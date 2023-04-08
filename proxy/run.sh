#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

touch error.log
touch access.log

docker rm -f proxy||true
docker run -d --name proxy \
    -p 4080:4080 \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
    -v $SSL_UNIFIED_CERT_FILE:/etc/nginx/certs/cert.pem \
    -v $SSL_KEY_FILE:/etc/nginx/certs/key.pem \
    -v $(pwd)/error.log:/var/log/nginx/error.log \
    -v $(pwd)/access.log:/var/log/nginx/access.log \
    nginx:stable-alpine

docker logs proxy

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

# curl "https://hubs.vevv.io:4080/http://hubs.vevv.io:9000/abc123?query=123&test=abc#1234"
# curl "https://proxy.dev1.xr.vevv.io:4080/https://uploads-prod.reticulum.io:443/files/728260ab-4e8f-4052-8e1a-c7fae3492989.glb"
# curl "https://hubs-proxy.vevv.io:4080"

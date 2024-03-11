#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

touch error.log
touch access.log

cp_and_replace nginx.template nginx.conf

docker rm -f proxy||true
docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name proxy --network haio \
    -p 4080:4080 \
    -p 5000:5000 \
    -v $(pwd)/nginx.conf:/etc/nginx/nginx.conf \
    -v $SSL_CERT_FILE:/etc/nginx/certs/cert.pem \
    -v $SSL_KEY_FILE:/etc/nginx/certs/key.pem \
    -v $(pwd)/error.log:/var/log/nginx/error.log \
    -v $(pwd)/access.log:/var/log/nginx/access.log \
    nginx:stable-alpine

docker logs proxy

# curl "https://hubs1.vevv.io:4080/http://${HUBS_HOST}:9000/abc123?query=123&test=abc#1234"
# curl "https://${PROXY_HOST}:4080/https://uploads-prod.reticulum.io:443/files/728260ab-4e8f-4052-8e1a-c7fae3492989.glb"
# curl "https://${PROXY_HOST}:4080"

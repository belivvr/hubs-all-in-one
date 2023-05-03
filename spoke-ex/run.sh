#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

cp nginx.spoke.template nginx.conf.spoke
replace_vars_in_files "nginx.conf.spoke"


docker rm -f spoke

docker run -d --name spoke \
-v $SSL_CERT_FILE:/etc/nginx/certs/cert.pem \
-v $SSL_KEY_FILE:/etc/nginx/certs/key.pem \
-v $(pwd)/nginx.conf.spoke:/etc/nginx/nginx.conf \
-p 9090:9090 \
spoke

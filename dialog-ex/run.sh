#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f dialog

docker run -d --name dialog \
-p $DIALOG_PORT:4443 \
-v $SSL_CERT_FILE:/app/certs/fullchain.pem \
-v $SSL_KEY_FILE:/app/certs/privkey.pem \
-v $PERMS_PUB_FILE:/app/certs/perms.pub.pem \
dialog

docker logs dialog

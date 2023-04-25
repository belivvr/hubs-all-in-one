#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f dialog

# -t옵션 반드시 있어야 한다. 없으면 아래 에러 난다.
# TypeError: process.stdin.setRawMode is not a function
docker run -dt --name dialog \
-p $DIALOG_PORT:4443 \
-v $SSL_CERT_FILE:/app/certs/fullchain.pem \
-v $SSL_KEY_FILE:/app/certs/privkey.pem \
-v $PERMS_PUB_FILE:/app/certs/perms.pub.pem \
-e MEDIASOUP_LISTEN_IP="0.0.0.0" \
dialog

docker logs dialog

# MEDIASOUP_ANNOUNCED_IP는 LISTEN_IP와 다르다 공개IP가 설정되어야 한다.
# -e MEDIASOUP_ANNOUNCED_IP="0.0.0.0" \ 아마도 오류
# MEDIASOUP_MIN_PORT
# MEDIASOUP_MAX_PORT
# DOMAIN

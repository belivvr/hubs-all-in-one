exit 1
MEDIASOUP_ANNOUNCED_IP 구해오는 스크립트 여기다가 작성해라

#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

docker rm -f dialog

# -t옵션 반드시 있어야 한다. 없으면 아래 에러 난다.

docker run -d --name dialog \
--network="host" \
-v $SSL_CERT_FILE:/app/certs/fullchain.pem \
-v $SSL_KEY_FILE:/app/certs/privkey.pem \
-v $PERMS_PUB_FILE:/app/certs/perms.pub.pem \
-e MEDIASOUP_LISTEN_IP="0.0.0.0" \
-e MEDIASOUP_ANNOUNCED_IP="49.50.166.94" \
-e INTERACTIVE="false" \
dialog

docker logs dialog

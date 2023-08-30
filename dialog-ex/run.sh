#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

docker rm -f dialog

MEDIASOUP_ANNOUNCED_IP=$(curl "https://ipinfo.io/ip")

# --network="host" 사용하는 이유
# dialog는 40000-49999/tcp/udp를 사용한다.
# 그러나 포트 맵핑을 하면 시간이 오래 걸린다.
# 그리고 사용 중인 포트가 있을 가능성이 높다.
# 그래서 실행에 실패하다.
docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name dialog \
--network="host" \
-v $SSL_CERT_FILE:/app/certs/fullchain.pem \
-v $SSL_KEY_FILE:/app/certs/privkey.pem \
-v $PERMS_PUB_FILE:/app/certs/perms.pub.pem \
-e MEDIASOUP_LISTEN_IP="0.0.0.0" \
-e MEDIASOUP_ANNOUNCED_IP=${MEDIASOUP_ANNOUNCED_IP} \
-e INTERACTIVE="false" \
dialog

docker logs dialog

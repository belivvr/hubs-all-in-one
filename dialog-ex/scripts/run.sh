#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./.env

sh ./check_cert_expiration.sh
sh ./initialize_hostnames.sh

cd $WORKDIR/dialog

mkdir -p certs

cp $SSL_CERT_FILE ./certs/fullchain.pem
cp $SSL_KEY_FILE ./certs/privkey.pem
cp $PERMS_PUB_FILE ./certs/perms.pub.pem

export MEDIASOUP_LISTEN_IP=0.0.0.0
export MEDIASOUP_ANNOUNCED_IP=0.0.0.0

npm start

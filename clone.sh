#!/bin/bash
set -e
cd "$(dirname "$0")"

. ./env.sh

CERTS="$(pwd)/certs"
SSL_CERT_FILE="$CERTS/vevv.io_202303247.unified.crt.pem"
SSL_KEY_FILE="$CERTS/vevv.io_202303247.key.pem"

# hubs
[ ! -d "hubs" ] && git clone https://github.com/belivvr/hubs.git

mkdir -p ./hubs/certs
cp $SSL_CERT_FILE ./hubs/certs/cert.pem
cp $SSL_KEY_FILE ./hubs/certs/key.pem

cp_and_replace ./hubs/env.template ./hubs/.env
cp_and_replace ./hubs/nginx.conf.template ./hubs/nginx.conf
cp_and_replace ./hubs/admin/env.template ./hubs/admin/.env
cp_and_replace ./hubs/admin/nginx.conf.template ./hubs/admin/nginx.conf

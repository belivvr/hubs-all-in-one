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

# hubs
[ ! -d "reticulum" ] && git clone https://github.com/belivvr/reticulum.git

mkdir -p ./reticulum/certs
cp $SSL_CERT_FILE ./reticulum/certs/cert.pem
cp $SSL_KEY_FILE ./reticulum/certs/key.pem

cp_and_replace ./reticulum/env.template ./reticulum/.env
cp_and_replace ./reticulum/dev.exs.template ./reticulum/dev.exs
cp_and_replace ./reticulum/runtime.exs.template ./reticulum/runtime.exs
cp_and_replace ./reticulum/.vscode/launch.json.template ./reticulum/.vscode/launch.json

#!/bin/bash
set -ex
cd "$(dirname "$0")"

. ./env.sh

# hubs
[ ! -d "hubs" ] && git clone https://github.com/belivvr/hubs.git

mkdir -p ./hubs/certs
cp $SSL_CERT_FILE ./hubs/certs/cert.pem
cp $SSL_KEY_FILE ./hubs/certs/key.pem

cp_and_replace ./hubs/env.template ./hubs/.env
cp_and_replace ./hubs/nginx.conf.template ./hubs/nginx.conf
cp_and_replace ./hubs/admin/env.template ./hubs/admin/.env
cp_and_replace ./hubs/admin/nginx.conf.template ./hubs/admin/nginx.conf

# reticulum
[ ! -d "reticulum" ] && git clone https://github.com/belivvr/reticulum.git

mkdir -p ./reticulum/certs
cp $SSL_CERT_FILE ./reticulum/certs/cert.pem
cp $SSL_KEY_FILE ./reticulum/certs/key.pem
cp $PERMS_PRV_FILE ./reticulum/certs/perms.prv.pem

cp_and_replace ./reticulum/env.template ./reticulum/.env
add_env_var_to_file "EVENT_ENTER_URL" "./reticulum/.env" "EVENT_ENTER_URL=\${EVENT_ENTER_URL}"
add_env_var_to_file "EVENT_EXIT_URL" "./reticulum/.env" "EVENT_EXIT_URL=\${EVENT_EXIT_URL}"
add_env_var_to_file "EVENT_URL" "./reticulum/.env" "EVENT_URL=\${EVENT_URL}"
cp_and_replace ./reticulum/dev.exs.template ./reticulum/config/dev.exs
add_env_var_to_file "EVENT_ENTER_URL" "./reticulum/config/dev.exs" "config :ret, :event_enter_url, \\\"\${EVENT_ENTER_URL}\\\""
add_env_var_to_file "EVENT_EXIT_URL" "./reticulum/config/dev.exs" "config :ret, :event_exit_url, \\\"\${EVENT_EXIT_URL}\\\""
add_env_var_to_file "EVENT_URL" "./reticulum/config/dev.exs" "config :ret, :event_url, \\\"\${EVENT_URL}\\\""
cp_and_replace ./reticulum/runtime.exs.template ./reticulum/config/runtime.exs
cp_and_replace ./reticulum/.vscode/launch.json.template ./reticulum/.vscode/launch.json

# dialog
[ ! -d "dialog" ] && git clone https://github.com/belivvr/dialog.git

mkdir -p ./dialog/certs
cp $SSL_CERT_FILE ./dialog/certs/cert.pem
cp $SSL_KEY_FILE ./dialog/certs/key.pem
cp $PERMS_PUB_FILE ./dialog/certs/perms.pub.pem

# spoke
[ ! -d "spoke" ] && git clone https://github.com/belivvr/spoke.git

mkdir -p ./spoke/certs
cp $SSL_CERT_FILE ./spoke/certs/cert.pem
cp $SSL_KEY_FILE ./spoke/certs/key.pem

cp_and_replace ./spoke/env.template ./spoke/.env.prod
cp_and_replace ./spoke/nginx.template ./spoke/nginx.conf

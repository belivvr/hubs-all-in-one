#!/bin/bash
set -ex
cd "$(dirname "$0")"

. ./env.sh

clone_repo() {
  local repo_url="$1"
  local repo_dir="$2"

  if [ -d "$repo_dir" ] && [ -z "$(ls -A "$repo_dir")" ]; then
    rm -rf "$repo_dir"
  fi

  if [ ! -d "$repo_dir" ]; then
    git clone "$repo_url" "$repo_dir"
  fi
}

# hubs
clone_repo "https://github.com/belivvr/hubs.git" "hubs"

mkdir -p ./hubs/certs
cp $SSL_CERT_FILE ./hubs/certs/cert.pem
cp $SSL_KEY_FILE ./hubs/certs/key.pem

cp_and_replace ./hubs/env.template ./hubs/.env
cp_and_replace ./hubs/nginx.conf.template ./hubs/nginx.conf
cp_and_replace ./hubs/admin/env.template ./hubs/admin/.env
cp_and_replace ./hubs/admin/nginx.conf.template ./hubs/admin/nginx.conf

# reticulum
clone_repo "https://github.com/belivvr/reticulum.git" "reticulum"

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
clone_repo "https://github.com/belivvr/dialog.git" "dialog"

mkdir -p ./dialog/certs
cp $SSL_CERT_FILE ./dialog/certs/cert.pem
cp $SSL_KEY_FILE ./dialog/certs/key.pem
cp $PERMS_PUB_FILE ./dialog/certs/perms.pub.pem

# spoke
clone_repo "https://github.com/belivvr/spoke.git" "spoke"

mkdir -p ./spoke/certs
cp $SSL_CERT_FILE ./spoke/certs/cert.pem
cp $SSL_KEY_FILE ./spoke/certs/key.pem

cp_and_replace ./spoke/env.template ./spoke/.env.prod
cp_and_replace ./spoke/nginx.template ./spoke/nginx.conf

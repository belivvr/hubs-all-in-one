#!/bin/bash
set -ex
cd "$(dirname "$0")"

# 첫 번째 파라미터에 따라 환경 파일을 로드합니다.
if [ "$1" == "prod" ]; then
  . ./env.sh
elif [ "$1" == "dev" ]; then
  . ./env.dev.sh
else
  echo "Error: You must specify 'prod' or 'dev' as the first parameter."
  exit 1
fi

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

# 두 번째 파라미터가 없거나 dialog일 때 dialog 실행
if [ -z "$2" ] || [ "$2" == "dialog" ]; then
  # dialog
  clone_repo "https://github.com/belivvr/dialog.git" "dialog"

  mkdir -p ./dialog/certs
  rm -rf ./dialog/certs/*.pem
  cp $SSL_CERT_FILE ./dialog/certs/cert.pem
  cp $SSL_KEY_FILE ./dialog/certs/key.pem
  cp $PERMS_PUB_FILE ./dialog/certs/perms.pub.pem
fi

# 두 번째 파라미터가 없거나 hubs일 때 dialog를 제외한 나머지 실행
# hubs는 cnu에서 dialog제외하고 실행하기 위한 옵션
if [ -z "$2" ] || [ "$2" == "hubs" ]; then
  # hubs
  clone_repo "https://github.com/belivvr/hubs.git" "hubs"

  mkdir -p ./hubs/certs
  rm -rf ./hubs/certs/*.pem

  echo $SSL_CERT_FILE 
  echo $SSL_KEY_FILE

  cp $SSL_CERT_FILE ./hubs/certs/cert.pem
  cp $SSL_KEY_FILE ./hubs/certs/key.pem

  if [ "$1" == "dev" ]; then
    cp_and_replace ./hubs/env.dev.template ./hubs/.env
  else
    cp_and_replace ./hubs/env.template ./hubs/.env
  fi
  cp_and_replace ./hubs/nginx.conf.template ./hubs/nginx.conf
  cp_and_replace ./hubs/admin/env.template ./hubs/admin/.env
  cp_and_replace ./hubs/admin/nginx.conf.template ./hubs/admin/nginx.conf

  # reticulum
  clone_repo "https://github.com/belivvr/reticulum.git" "reticulum"

  mkdir -p ./reticulum/certs
  rm -rf ./reticulum/certs/*.pem
  cp $SSL_CERT_FILE ./reticulum/certs/cert.pem
  cp $SSL_KEY_FILE ./reticulum/certs/key.pem
  cp $PERMS_PRV_FILE ./reticulum/certs/perms.prv.pem

  rm -rf ./reticulum/.env
  cp_and_replace ./reticulum/env.template ./reticulum/.env

  add_env_var_to_file "LOGGING_URL" "./reticulum/.env" "LOGGING_URL=\${LOGGING_URL}"
  cp_and_replace ./reticulum/dev.exs.template ./reticulum/config/dev.exs
  add_env_var_to_file "LOGGING_URL" "./reticulum/config/dev.exs" "config :ret, :logging_url, \\\"\${LOGGING_URL}\\\""
  cp_and_replace ./reticulum/runtime.exs.template ./reticulum/config/runtime.exs
  cp_and_replace ./reticulum/.vscode/launch.json.template ./reticulum/.vscode/launch.json

  # spoke
  clone_repo "https://github.com/belivvr/spoke.git" "spoke"

  mkdir -p ./spoke/certs
  rm -rf ./spoke/certs/*.pem
  cp $SSL_CERT_FILE ./dialo
  cp $SSL_CERT_FILE ./spoke/certs/cert.pem
  cp $SSL_KEY_FILE ./spoke/certs/key.pem

  cp_and_replace ./spoke/env.template ./spoke/.env.prod
  cp_and_replace ./spoke/nginx.template ./spoke/nginx.conf
fi

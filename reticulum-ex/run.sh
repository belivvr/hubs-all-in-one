#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

cp dev.exs.template dev.exs
replace_vars_in_files "dev.exs"

cp runtime.exs.template runtime.exs
replace_vars_in_files "runtime.exs"

docker rm -f reticulum

docker run -d --name reticulum \
-v $SSL_CERT_FILE:/app/reticulum/priv/dev-ssl.cert \
-v $SSL_KEY_FILE:/app/reticulum/priv/dev-ssl.key \
-w /app/reticulum \
-v /storage/dev:/app/reticulum/storage/dev \
-v $(pwd)/dev.exs:/app/reticulum/config/dev.exs \
-v $(pwd)/runtime.exs:/app/reticulum/config/runtime.exs \
-p 4000:4000 \
-e DB_HOST="$DB_HOST" \
-e DIALOG_HOSTNAME="$DIALOG_HOST" \
-e DIALOG_PORT="$DIALOG_PORT" \
-e PERMS_KEY="$(cat $PERMS_PRV_FILE)" \
-e HUBS_ADMIN_INTERNAL_HOSTNAME="$HUBS_HOST" \
-e HUBS_CLIENT_INTERNAL_HOSTNAME="$HUBS_HOST" \
-e SPOKE_INTERNAL_HOSTNAME="$HUBS_HOST" \
-e POSTGREST_INTERNAL_HOSTNAME="$POSTGREST_HOST" \
reticulum sh -c "mix ecto.create && mix phx.server"

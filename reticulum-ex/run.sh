#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f reticulum
docker run -d --name reticulum \
-v $SSL_CERT_FILE:/app/reticulum/priv/dev-ssl.cert \
-v $SSL_KEY_FILE:/app/reticulum/priv/dev-ssl.key \
-w /app/reticulum \
-v $(pwd)/dev:/app/reticulum/storage/dev \
-v $(pwd)/dev.exs:/app/reticulum/config/dev.exs \
-p 4000:4000 \
-e DB_HOST="$DB_HOST" \
-e DIALOG_HOSTNAME="$DIALOG_HOSTNAME" \
-e DIALOG_PORT="$DIALOG_PORT" \
-e PERMS_KEY="$(cat $PERMS_PRV_FILE)" \
-e HUBS_ADMIN_INTERNAL_HOSTNAME="$DOMAIN" \
-e HUBS_CLIENT_INTERNAL_HOSTNAME="$DOMAIN" \
-e SPOKE_INTERNAL_HOSTNAME="$DOMAIN" \
reticulum sh -c "mix ecto.create && iex -S mix phx.server"

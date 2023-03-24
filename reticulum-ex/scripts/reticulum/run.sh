#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

sh ../check_cert_expiration.sh
sh ../initialize_hostnames.sh

docker run -p 5432:5432 --rm --name $DB_HOST -d -e POSTGRES_PASSWORD=$DB_PASSWORD postgres:11-bullseye || true

export DB_HOST=$DB_HOST
export DIALOG_HOSTNAME=$DIALOG_HOSTNAME
export DIALOG_PORT=$DIALOG_PORT
export PERMS_KEY="$(cat $PERMS_PRV_FILE)"
export HUBS_ADMIN_INTERNAL_HOSTNAME="$DOMAIN"
export HUBS_CLIENT_INTERNAL_HOSTNAME="$DOMAIN"
export SPOKE_INTERNAL_HOSTNAME="$DOMAIN"
# export POSTGREST_INTERNAL_HOSTNAME="$DOMAIN"

cp ./dev.exs $WORKDIR/reticulum/config/dev.exs

cd $WORKDIR/reticulum

cp $SSL_CERT_FILE ./priv/dev-ssl.cert
cp $SSL_KEY_FILE ./priv/dev-ssl.key

mix ecto.create

iex -S mix phx.server

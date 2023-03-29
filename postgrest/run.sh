#!/bin/sh
set -e
cd "$(dirname "$0")"
# . ../.env

docker run -p 5432:5432 --rm --name $DB_HOST -d -e POSTGRES_PASSWORD=$DB_PASSWORD postgres:11-bullseye || true

# reticulum의 설정이 바뀌면 reticulum-jwk.json을 새로 생성해야 한다.
# jwk = Application.get_env(:ret, Ret.PermsToken)[:perms_key] |> JOSE.JWK.from_pem(); JOSE.JWK.to_file("reticulum-jwk.json", jwk)

# ./postgrest reticulum.conf

docker rm -f postgrest
docker run -d -p 3000:3000 \
-v $(pwd)/reticulum.conf:/app/reticulum.conf \
-v $(pwd)/reticulum-jwk.json:/app/reticulum-jwk.json \
--name postgrest \
postgrest sh -c "./postgrest /app/reticulum.conf"

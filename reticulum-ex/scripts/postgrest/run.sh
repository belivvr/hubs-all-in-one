#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

apt install -y libpq-dev
# wget https://github.com/PostgREST/postgrest/releases/download/v9.0.0/postgrest-v9.0.0-linux-static-x64.tar.xz
# tar -xf postgrest-v9.0.0-linux-static-x64.tar.xz

# reticulum의 설정이 바뀌면 reticulum-jwk.json을 새로 생성해야 한다.
# jwk = Application.get_env(:ret, Ret.PermsToken)[:perms_key] |> JOSE.JWK.from_pem(); JOSE.JWK.to_file("reticulum-jwk.json", jwk)

./postgrest reticulum.conf

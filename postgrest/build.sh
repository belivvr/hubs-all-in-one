#!/bin/sh
set -e
cd "$(dirname "$0")"


# reticulum의 설정이 바뀌면 reticulum-jwk.json을 새로 생성해야 한다.
# jwk = Application.get_env(:ret, Ret.PermsToken)[:perms_key] |> JOSE.JWK.from_pem(); JOSE.JWK.to_file("reticulum-jwk.json", jwk)
docker build -t postgrest .

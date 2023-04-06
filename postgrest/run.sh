#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

docker rm -f postgrest

docker run -d --name postgrest \
-p 3000:3000 \
-v $(pwd)/postgrest.conf:/app/postgrest.conf \
-v $PERMS_JWK_FILE:/app/perms-jwk.json \
postgrest sh -c "./postgrest /app/postgrest.conf"

#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..

# 첫 번째 파라미터에 따라 환경 파일을 로드합니다.
if [ "$1" == "prod" ]; then
  . ./env.sh
elif [ "$1" == "dev" ]; then
  . ./env.dev.sh
else
  echo "Error: You must specify 'prod' or 'dev' as the first parameter."
  exit 1
fi

cd $THISDIR

cp_and_replace postgrest.template postgrest.conf

docker rm -f postgrest

docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name postgrest \
-p 3000:3000 \
-v $(pwd)/postgrest.conf:/app/postgrest.conf \
-v $PERMS_JWK_FILE:/app/perms-jwk.json \
postgrest sh -c "./postgrest /app/postgrest.conf"

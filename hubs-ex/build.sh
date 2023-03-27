#!/bin/sh
set -e
cd "$(dirname "$0")"

# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd "$(dirname "$0")"

rm -rf hubs
git clone https://github.com/mozilla/hubs.git

docker rm -f hubs ||true
docker rmi hubs|| true
docker build -t hubs .

# cd hubs
# npm ci

# cd admin
# npm ci --legacy-peer-deps

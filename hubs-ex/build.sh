#!/bin/bash
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

rm -rf hubs
git clone https://github.com/mozilla/hubs.git

cp client.env hubs/.env
replace_vars_in_files "hubs/.env"

cp admin.env hubs/admin/.env
replace_vars_in_files "hubs/admin/.env"

docker build -t client -f Dockerfile.client .
docker build -t admin -f Dockerfile.admin .

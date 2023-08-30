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
cd hubs
#Commits on Jul 19, 2023
git checkout f099ec6cb9a15c8f7554ffdbec592f9abf6c7267
cd ..

cp client.env hubs/.env
replace_vars_in_files "hubs/.env"

cp admin.env hubs/admin/.env
replace_vars_in_files "hubs/admin/.env"

cp -r ./hubs-custom/* ./hubs/

docker build -t client -f Dockerfile.client .
docker build -t admin -f Dockerfile.admin .

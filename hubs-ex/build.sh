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
#Commits on Fri Sep 15 11:22:17 2023 +0200
git checkout 8653fdd4c74943f55928ed10548cd5de4e3295f2
cd ..

cp client.env hubs/.env
replace_vars_in_files "hubs/.env"

cp admin.env hubs/admin/.env
replace_vars_in_files "hubs/admin/.env"

cp -r ./hubs-custom/* ./hubs/

docker build -t client -f Dockerfile.client .
docker build -t admin -f Dockerfile.admin .

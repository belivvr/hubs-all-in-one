#!/bin/sh
set -e
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

rm -rf reticulum
git clone https://github.com/mozilla/reticulum.git
rm -rf reticulum/.git

docker rm -f reticulum ||true
docker rmi reticulum|| true
docker build -t reticulum .

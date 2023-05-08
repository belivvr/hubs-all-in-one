#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

rm -rf reticulum
git clone https://github.com/mozilla/reticulum.git

# 여기 임시
cp ./auth_channel.ex    reticulum/lib/ret_web/channels/auth_channel.ex
# cp ./app_config.ex      reticulum/lib/ret/app_config.ex

docker build -t reticulum .

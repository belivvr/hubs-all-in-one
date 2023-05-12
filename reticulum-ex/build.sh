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

# 이메일 인증 프로세스 무시
cp ./auth_channel.ex    reticulum/lib/ret_web/channels/auth_channel.ex
# 오디오 설정 관련 때문에 넣었었다.
# cp ./app_config.ex      reticulum/lib/ret/app_config.ex

docker build -t reticulum .

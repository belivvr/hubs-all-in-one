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

docker build -t reticulum .

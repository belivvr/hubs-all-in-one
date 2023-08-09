#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

rm -rf Spoke
git clone https://github.com/mozilla/Spoke.git

cp -r ./Spoke-custom/* ./Spoke/

cp spoke.env Spoke/.env.prod
replace_vars_in_files "Spoke/.env.prod"

docker build -t spoke .

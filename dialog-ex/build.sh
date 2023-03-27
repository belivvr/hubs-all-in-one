#!/bin/sh
set -e
cd "$(dirname "$0")"

# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd "$(dirname "$0")"

rm -rf dialog
git clone https://github.com/mozilla/dialog.git
cd dialog

docker rm -f dialog ||true
docker rmi dialog|| true
docker build -t dialog .

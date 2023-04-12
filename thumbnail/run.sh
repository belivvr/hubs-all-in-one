#!/bin/sh
set -e
# cd "$(dirname "$0")"
# THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
# cd ..
# . ./.env
# cd $THISDIR

docker rm -f thumbnail
docker run -d --name thumbnail \
-p 5000:5000 \
thumbnail

#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./.env
cd $THISDIR

#  포트가 사용 중이면 아래와 같은 오류가 발생한다.
# 2023-04-05 07:28:34.603 UTC [152] FATAL:  password authentication failed for user "postgres"
# 2023-04-05 07:28:34.603 UTC [152] DETAIL:  Password does not match for user "postgres".
#         Connection matched pg_hba.conf line 95: "host all all all md5"

docker rm -f $DB_HOST
docker run -p 5432:5432 --rm --name $DB_HOST -d -e POSTGRES_PASSWORD="$DB_PASSWORD" postgres:11-bullseye || true

#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# .env가 현재 경로를 기준으로 파일을 가져온다.
cd ..
. ./env.sh
cd $THISDIR

#  포트가 사용 중이면 아래와 같은 오류가 발생한다.
# 2023-04-05 07:28:34.603 UTC [152] FATAL:  password authentication failed for user "postgres"
# 2023-04-05 07:28:34.603 UTC [152] DETAIL:  Password does not match for user "postgres".
#         Connection matched pg_hba.conf line 95: "host all all all md5"

docker rm -f db
docker run -p 5432:5432 --rm --name db -d -e POSTGRES_PASSWORD="$DB_PASSWORD" postgres:11-bullseye || true

container_name="db"
log_message="listening on IPv4 address \"0.0.0.0\", port 5432"

while ! docker logs "$container_name" 2>&1 | grep -q "$log_message"; do
    sleep 1
done

docker exec db psql -U postgres -c "CREATE DATABASE ret_dev;"
docker exec db psql -U postgres -d ret_dev -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"

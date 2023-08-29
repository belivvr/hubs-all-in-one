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

if [ "$1" = "prod" ]; then
    mkdir -p "$DB_VOLUME_DIR"

    #마운트 실행
    mount -t nfs $DB_NAS_LOCATION $DB_VOLUME_DIR

    #마운트 정보 유지 설정(fstab 설정)
    echo "$DB_NAS_LOCATION $DB_VOLUME_DIR nfs ,defaults 0 0" | sudo tee -a /etc/fstab

    docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always -p 5432:5432 --name db -d -e POSTGRES_PASSWORD="$DB_PASSWORD" -v "$DB_VOLUME_DIR":/var/lib/postgresql/data postgres:11-bullseye || true
    sleep 5
else
    docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always -p 5432:5432 --name db -d -e POSTGRES_PASSWORD="$DB_PASSWORD" postgres:11-bullseye || true
fi

container_name="db"
log_message="listening on IPv4 address \"0.0.0.0\", port 5432"

while ! docker logs "$container_name" 2>&1 | grep -q "$log_message"; do
    sleep 1
done

docker exec db psql -U postgres -c "CREATE DATABASE ret_dev;"
docker exec db psql -U postgres -d ret_dev -c "CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"
docker exec db psql -U postgres -d ret_dev -c "ALTER USER $DB_USER WITH SUPERUSER;"
docker exec db psql -U postgres -d ret_dev -c "GRANT ALL PRIVILEGES ON DATABASE ret_dev TO $DB_USER;"
docker exec db psql -U postgres -d ret_dev -c "GRANT CREATE ON DATABASE ret_dev TO $DB_USER;"

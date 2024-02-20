#!/bin/bash
cd "$(dirname "$0")"

bash clone.sh

docker network create haio

docker rm -f postgrest
docker rm -f dialog
docker rm -f proxy
docker rm -f reticulum
# docker rm -f client
# docker rm -f admin
docker rm -f db
docker rm -f spoke
docker rm -f thumbnail

docker volume ls -q | xargs docker volume rm

bash dialog-ex/build.sh
bash postgrest/build.sh
# bash hubs-ex/build.sh
bash hubs/build.sh
bash hubs/admin/build.sh
bash spoke-ex/build.sh
bash thumbnail/build.sh
bash reticulum-ex/build.sh

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

if [ "$1" = "prod" ]; then
        #nfs-common 패키지 설치
        sudo apt-get install nfs-common

        #NFS 관련 데몬 기동
        sudo systemctl start rpcbind.service

        #rpcbind가 자동으로 기동되도록 설정
        sudo systemctl enable rpcbind.service

        bash db/run.sh prod
        bash reticulum-ex/run.sh prod
else
        bash db/run.sh
        bash reticulum-ex/run.sh
fi

bash dialog-ex/run.sh
# bash hubs-ex/run-admin.sh
# bash hubs-ex/run-client.sh
bash hubs/run.sh
bash hubs/admin/run.sh
bash spoke-ex/run.sh
bash postgrest/run.sh
bash thumbnail/run.sh
bash proxy/run.sh

docker logs -f reticulum

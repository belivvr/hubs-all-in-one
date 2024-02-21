#!/bin/bash
cd "$(dirname "$0")"

bash clone.sh

docker network create haio

docker rm -f postgrest
docker rm -f proxy
docker rm -f db
docker rm -f spoke
docker rm -f thumbnail

docker volume ls -q | xargs docker volume rm

bash dialog/build.sh
bash postgrest/build.sh
bash hubs/build.sh
bash hubs/admin/build.sh
bash spoke/build.sh
bash thumbnail/build.sh
bash reticulum/build.sh

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

if [ "$1" = "prod" ]; then
        #nfs-common 패키지 설치
        sudo apt-get install nfs-common

        #NFS 관련 데몬 기동
        sudo systemctl start rpcbind.service

        #rpcbind가 자동으로 기동되도록 설정
        sudo systemctl enable rpcbind.service

        bash db/run.sh prod
        bash reticulum/run.sh prod
else
        bash db/run.sh
        bash reticulum/run.sh
fi

bash dialog/run.sh
bash hubs/run.sh
bash hubs/admin/run.sh
bash spoke/run.sh
bash postgrest/run.sh
bash thumbnail/run.sh
bash proxy/run.sh

docker logs -f reticulum

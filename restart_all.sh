#!/bin/bash
cd "$(dirname "$0")"

if [ "$1" != "prod" ] && [ "$1" != "dev" ]; then
      echo "Usage: $0 {prod|dev} [dialog|hubs]"
    exit 1
fi

bash clone.sh $1 $2

docker network create haio
docker rm -f postgrest
docker rm -f proxy
docker rm -f db
docker rm -f spoke
docker rm -f thumbnail
docker rm -f reticulum
docker rm -f dialog

docker volume ls -q | xargs docker volume rm

# 두 번째 파라미터가 없거나 dialog일 때 dialog 빌드
if [ -z "$2" ] || [ "$2" == "dialog" ]; then
    bash dialog/build.sh $1
fi

# 두 번째 파라미터가 없거나 hubs일 때 dialog를 제외한 나머지 빌드
if [ -z "$2" ] || [ "$2" == "hubs" ]; then
    bash postgrest/build.sh $1
    bash hubs/build.sh $1
    bash hubs/admin/build.sh $1
    bash spoke/build.sh $1
    bash thumbnail/build.sh $1
    bash reticulum/build.sh $1
fi

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

if [ "$1" = "prod" ]; then
        #nfs-common 
        sudo apt-get install nfs-common

        #NFS demon start
        sudo systemctl start rpcbind.service

        #rpcbind auto running setting
        sudo systemctl enable rpcbind.service        
fi        
        
bash run.sh $1 $2
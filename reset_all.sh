#!/bin/bash
cd "$(dirname "$0")"

if [ "$1" != "prod" ] && [ "$1" != "dev" ]; then
    echo "Usage: $0 {prod|dev}"
    exit 1
fi

bash clone.sh $1

docker network create haio

docker rm -f postgrest
docker rm -f proxy
docker rm -f db
docker rm -f spoke
docker rm -f thumbnail
docker rm -f reticulum
docker rm -f dialog

docker volume ls -q | xargs docker volume rm

bash dialog/build.sh $1
bash postgrest/build.sh $1
bash hubs/build.sh $1
bash hubs/admin/build.sh $1
bash spoke/build.sh $1
bash thumbnail/build.sh $1
bash reticulum/build.sh $1

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

if [ "$1" = "prod" ]; then
        #nfs-common 
        sudo apt-get install nfs-common

        #NFS demon start
        sudo systemctl start rpcbind.service

        #rpcbind auto running setting
        sudo systemctl enable rpcbind.service        
fi
        
        
bash db/run.sh $1
bash reticulum/run.sh $1
bash dialog/run.sh $1
bash hubs/run.sh $1
bash hubs/admin/run.sh $1
bash spoke/run.sh $1
bash postgrest/run.sh $1
bash thumbnail/run.sh $1
bash proxy/run.sh $1

docker logs -f reticulum

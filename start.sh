#!/bin/bash
cd "$(dirname "$0")"

if [ "$1" != "prod" ] && [ "$1" != "dev" ]; then
    echo "Usage: $0 {prod|dev}"
    exit 1
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

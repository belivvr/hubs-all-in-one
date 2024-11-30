#!/bin/bash
cd "$(dirname "$0")"

if [ "$1" != "prod" ] && [ "$1" != "dev" ]; then
    echo "Usage: $0 {prod|dev} [dialog|hubs]"
    exit 1
fi

# 두 번째 파라미터가 없거나 dialog일 때 dialog 실행
if [ -z "$2" ] || [ "$2" == "dialog" ]; then
    bash dialog/run.sh $1
fi

# 두 번째 파라미터가 없거나 hubs일 때 dialog를 제외한 나머지 실행
if [ -z "$2" ] || [ "$2" == "hubs" ]; then
    bash db/run.sh $1
    bash reticulum/run.sh $1
    bash hubs/run.sh $1
    bash hubs/admin/run.sh $1
    bash spoke/run.sh $1
    bash postgrest/run.sh $1
    bash thumbnail/run.sh $1
    bash proxy/run.sh $1
fi

docker logs -f reticulum

#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

docker rm -f my-cors-proxy

docker build -t my-cors-proxy:latest .

# Check if host.docker.internal is available
if getent hosts host.docker.internal >/dev/null 2>&1; then
    # Get IP address for host.docker.internal
    IP=$(getent hosts host.docker.internal | awk '{ print $1 }')
else
    # Get IP address for host system using ifconfig command
    IP=$(route -n | grep ^0.0.0.0 | awk '{ print $2 }')
fi

docker run -d \
    --add-host frosty-invoker.hubs.belivvr.com:$IP \
    -p 4080:4080 \
    --name my-cors-proxy \
    my-cors-proxy:latest

docker logs -f my-cors-proxy

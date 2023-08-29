#!/bin/sh
set -ex

docker rm -f thumbnail
docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name thumbnail \
-p 5000:5000 \
thumbnail

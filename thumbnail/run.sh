#!/bin/sh
set -ex

docker rm -f thumbnail
docker run -d --restart=always --name thumbnail \
-p 5000:5000 \
thumbnail

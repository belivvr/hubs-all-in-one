#!/bin/sh
set -ex
cd "$(dirname "$0")"

touch private.pem
touch public.pem
touch perms-jwk.json

docker run --rm -w /app -it -v $(pwd):/app python sh generate_by_docker.sh

mv private.pem ../perms.prv.pem
mv public.pem ../perms.pub.pem
mv perms-jwk.json ../perms-jwk.json

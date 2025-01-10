#!/bin/sh
set -ex
cd "$(dirname "$0")"
THISDIR=$(pwd)
# Load the .env file based on the current directory
cd ..

# Get the environment file from the first parameter
ENV_FILE="$1"

# Check if the environment file exists
if [ ! -f "$ENV_FILE" ]; then
  echo "Error: Environment file '$ENV_FILE' not found."
  exit 1
fi

# Source the environment file
source "$ENV_FILE"

cd $THISDIR

docker rm -f postgrest

docker run --log-opt max-size=10m --log-opt max-file=3 -d --restart=always --name postgrest \
-p 3000:3000 \
-v $(pwd)/postgrest.conf:/app/postgrest.conf \
-v $PERMS_JWK_FILE:/app/perms-jwk.json \
postgrest sh -c "./postgrest /app/postgrest.conf"

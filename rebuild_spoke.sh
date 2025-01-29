#!/bin/bash

# Remove existing spoke container and image
docker rm -f spoke
docker rmi -f spoke

# Build and run spoke
bash spoke/build.sh
bash spoke/run.sh 
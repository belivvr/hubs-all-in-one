#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./.env

cd $WORKDIR
rm -rf hubs
git clone https://github.com/mozilla/hubs.git

cd $WORKDIR/hubs
npm ci

cd $WORKDIR/hubs/admin
npm ci --legacy-peer-deps

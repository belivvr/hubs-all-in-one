#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

cd $WORKDIR
rm -rf reticulum
git clone https://github.com/mozilla/reticulum.git

cd $WORKDIR/reticulum
mkdir -p storage/dev
mix deps.get

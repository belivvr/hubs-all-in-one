#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./.env

cd $WORKDIR
rm -rf dialog
git clone https://github.com/mozilla/dialog.git

cd $WORKDIR/dialog
npm ci

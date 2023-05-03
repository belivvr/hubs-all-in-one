#!/bin/sh
set -ex
cd "$(dirname "$0")"

rm -rf dialog
git clone https://github.com/mozilla/dialog.git

docker build -t dialog .

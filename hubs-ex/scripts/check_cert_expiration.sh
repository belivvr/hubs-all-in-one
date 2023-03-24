#!/bin/sh
set -e
cd "$(dirname "$0")"
. ./.env

# check SSL FILES
expiration=$(openssl x509 -enddate -noout -in "$SSL_CERT_FILE" | cut -d= -f 2)
expiration_timestamp=$(date -d "$expiration" +%s)
now=$(date +%s)
seconds_until_expiration=$((expiration_timestamp - now))

if [ $seconds_until_expiration -le 0 ]; then
    echo "Certificate has expired!"
    exit 1
else
    echo "Certificate will expire in $seconds_until_expiration seconds"
fi

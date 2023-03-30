#!/bin/sh
set -e
cd "$(dirname "$0")"
. ../.env

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

# check PERMS FILES
# Verify private key
openssl rsa -in "$PERMS_PRV_FILE" -check -noout
private_key_check_result=$?

# Verify public key
openssl rsa -in "$PERMS_PRV_FILE" -pubout -outform PEM | diff -q - "$PERMS_PUB_FILE" >/dev/null 2>&1
public_key_check_result=$?

if [ $private_key_check_result -eq 0 ] && [ $public_key_check_result -eq 0 ]; then
    echo "Both private and public key files are valid."
else
    echo "Error: One or both key files are not valid."
    [ $private_key_check_result -ne 0 ] && echo "Private key file is not valid."
    [ $public_key_check_result -ne 0 ] && echo "Public key file is not valid."
fi

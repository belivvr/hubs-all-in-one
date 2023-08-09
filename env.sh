#!/bin/bash
set -e

CERTS="$(pwd)/certs"
SUFFIX="room.xrcloud.app"

SOURCE=(
    SSL_CERT_FILE="$CERTS/room.xrcloud.app_20230809AAD35.unified.crt.pem"
    SSL_KEY_FILE="$CERTS/room.xrcloud.app_20230809AAD35.key.pem"
    PERMS_PRV_FILE="$CERTS/perms.prv.pem"
    PERMS_PUB_FILE="$CERTS/perms.pub.pem"
    PERMS_JWK_FILE="$CERTS/perms-jwk.json"
    HUBS_HOST="${SUFFIX}"
    PROXY_HOST="${SUFFIX}"
    DB_HOST="${SUFFIX}"
    DB_USER="xrcloud"
    DB_PASSWORD="ENrrYdFyD3f"
    POSTGREST_HOST="${SUFFIX}"
    DIALOG_HOST="${SUFFIX}"
    DIALOG_PORT="4443"
    THUMBNAIL_HOST="${SUFFIX}"
     #입장과 퇴장시 이벤트 로그를 남겨줄 API를 지정한다. 레티큘럼에서만 사용.
    EVENT_ENTER_URL="https://xrcloud.app/api"
    EVENT_EXIT_URL="https://xrcloud.app/api"
    DB_VOLUME_DIR="/data3/postgres"
    DB_NAS_LOCATION="169.254.84.53:/n3048487_HaioProdDB"
    RETICULUM_STORAGE_DIR="/storage"
    STORAGE_NAS_LOCATION="169.254.84.53:/n3048487_HaioProdStorage"
)

array_length=${#SOURCE[@]}

function replace_vars_in_files() {
    FILE=$1

    for ((i = 0; i < array_length; i++)); do

        IFS="=" read -r NAME VALUE <<<"${SOURCE[i]}"
        echo "$NAME $VALUE $FILE"
        sed -i "s/\${${NAME}}/${VALUE//\//\\/}/g" $FILE
    done
}

for ((i = 0; i < array_length; i++)); do
    export "${SOURCE[i]}"
    echo "${SOURCE[i]}"
done

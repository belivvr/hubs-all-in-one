#!/bin/bash
set -e

CERTS="$(pwd)/certs"
SUFFIX="cnumetaxr.jnu.ac.kr"

SOURCE=(
    SSL_CERT_FILE="$CERTS/wildcard.jnu.ac.kr.unified.crt"
    SSL_KEY_FILE="$CERTS/open_wildcard.jnu.ac.kr.key"
    PERMS_PRV_FILE="$CERTS/perms.prv.pem"
    PERMS_PUB_FILE="$CERTS/perms.pub.pem"
    PERMS_JWK_FILE="$CERTS/perms-jwk.json"
    HUBS_HOST="${SUFFIX}"
    PROXY_HOST="${SUFFIX}"
    DB_HOST="${SUFFIX}"
    DB_USER="xrcloud"
    DB_PASSWORD="xrcloud123!"
    POSTGREST_HOST="${SUFFIX}"
    DIALOG_HOST="${SUFFIX}"
    DIALOG_PORT="4443"
    THUMBNAIL_HOST="${SUFFIX}"
     #입장과 퇴장시 이벤트 로그를 남겨줄 API를 지정한다. 레티큘럼에서만 사용.
    EVENT_ENTER_URL="https://cnumeta.jnu.ac.kr/api/v1/rooms/logs"
    EVENT_EXIT_URL="https://cnumeta.jnu.ac.kr/api/v1/rooms/logs"
    DB_VOLUME_DIR="/data/postgres"
    DB_NAS_LOCATION="169.254.170.76:/n009102_xrcloudJnuDBVolume"
    RETICULUM_STORAGE_DIR="/storage"
    STORAGE_NAS_LOCATION="169.254.170.76:/n009102_xrcloudJnu"
    XRCLOUD_BACKEND_URL="https://cnu-api.vevv.io:3200"
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

function cp_and_replace() {
    TEMPLATE=$1
    FILE=$2

    cp $TEMPLATE $FILE

    for ((i = 0; i < array_length; i++)); do

        IFS="=" read -r NAME VALUE <<<"${SOURCE[i]}"
        sed -i "s/\${${NAME}}/${VALUE//\//\\/}/g" $FILE
    done
}

for ((i = 0; i < array_length; i++)); do
    export "${SOURCE[i]}"
done

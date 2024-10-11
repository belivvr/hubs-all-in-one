#!/bin/bash
set -e

CERTS="$(pwd)/certs"
HUBS_HOST="xrcloud-room.dev.belivvr.com"
DIALOG_HOST="xrcloud-room.dev.belivvr.com"
XRCLOUD_HOST="xrcloud-api.dev.belivvr.com"

SOURCE=(
    SSL_CERT_FILE="$CERTS/dev.belivvr.com_20240304.all.crt.pem"
    SSL_KEY_FILE="$CERTS/dev.belivvr.com_20240304.key.pem"
    PERMS_PRV_FILE="$CERTS/perms.prv.pem"
    PERMS_PUB_FILE="$CERTS/perms.pub.pem"
    PERMS_JWK_FILE="$CERTS/perms-jwk.json"
    HUBS_HOST="${HUBS_HOST}"
    PROXY_HOST="${HUBS_HOST}"
    DB_HOST="${HUBS_HOST}"
    DB_USER="xrcloud"
    DB_PASSWORD="xrcloud-dev!"
    POSTGREST_HOST="${HUBS_HOST}"
    DIALOG_HOST="${DIALOG_HOST}"
    DIALOG_PORT="4443"
    THUMBNAIL_HOST="${HUBS_HOST}"
    EVENT_ENTER_URL="https://${HUBS_HOST}/api"
    EVENT_EXIT_URL="https://${HUBS_HOST}/api"
    EVENT_URL="https://${XRCLOUD_HOST}/events/hub"
    DB_VOLUME_DIR="/app/haio/db"
    RETICULUM_STORAGE_DIR="/data/haio/storage"
    XRCLOUD_BACKEND_URL="https://${XRCLOUD_HOST}"
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

    echo "Copying $TEMPLATE to $FILE" # 디버깅 출력 추가
    cp $TEMPLATE $FILE                # 템플릿 파일 복사

    if [ $? -ne 0 ]; then
        echo "Failed to copy $TEMPLATE to $FILE"
        exit 1
    fi

    for ((i = 0; i < array_length; i++)); do
        IFS="=" read -r NAME VALUE <<<"${SOURCE[i]}"
        echo "Replacing \${${NAME}} with ${VALUE} in ${FILE}" # 디버깅 출력 추가
        sed -i "s/\${${NAME}}/${VALUE//\//\\/}/g" $FILE
    done
}

function add_env_var_to_file() {
    local env_var_name=$1
    local file_name=$2
    local formatted_string=$3
    local env_var_value=$(printenv "$env_var_name")

    if [ ! -z "$env_var_value" ]; then
        # 평가하여 formatted_string 내에서 환경변수 값을 대체
        local to_add=$(eval echo "$formatted_string")
        echo "$to_add" >>"$file_name"
    fi
}

for ((i = 0; i < array_length; i++)); do
    export "${SOURCE[i]}"
done

#!/bin/bash
set -e

CERTS="$(pwd)/certs"
SUFFIX="1.vevv.io"

SOURCE=(
    SSL_CERT_FILE="$CERTS/vevv.io_202303247.unified.crt.pem"
    SSL_KEY_FILE="$CERTS/vevv.io_202303247.key.pem"
    PERMS_PRV_FILE="$CERTS/perms.prv.pem"
    PERMS_PUB_FILE="$CERTS/perms.pub.pem"
    PERMS_JWK_FILE="$CERTS/perms-jwk.json"
    HUBS_HOST="hubs-${SUFFIX}"
    PROXY_HOST="proxy-${SUFFIX}"
    DB_HOST="db-${SUFFIX}"
    DB_USER="xrcloud"
    DB_PASSWORD="xrcloud123!"
    POSTGREST_HOST="postgrest-${SUFFIX}"
    DIALOG_HOST="dialog-${SUFFIX}"
    DIALOG_PORT="4443"
    THUMBNAIL_HOST="thumbnail-${SUFFIX}"
     #입장과 퇴장시 이벤트 로그를 남겨줄 API를 지정한다. 레티큘럼에서만 사용.
    EVENT_ENTER_URL="xrcloud의 로그 생성 url"
    EVENT_EXIT_URL="xrcloud의 로그 삭제 url"
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

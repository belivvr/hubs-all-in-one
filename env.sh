#!/bin/bash
CERTS="$(pwd)/certs"
SUFFIX="1.vevv.io"

SOURCE=(
    "SSL_CERT_FILE"
    "SSL_KEY_FILE"
    "PERMS_PRV_FILE"
    "PERMS_PUB_FILE"
    "PERMS_JWK_FILE"
    "HUBS_HOST"
    "PROXY_HOST"
    "DB_HOST"
    "DB_USER"
    "DB_PASSWORD"
    "POSTGREST_HOST"
    "DIALOG_HOST"
    "DIALOG_PORT"
    "THUMBNAIL_HOST"
)
TARGET=(
    "$CERTS/vevv.io_202303247.unified.crt.pem"
    "$CERTS/vevv.io_202303247.key.pem"
    "$CERTS/perms.prv.pem"
    "$CERTS/perms.pub.pem"
    "$CERTS/perms-jwk.json"
    "hubs${SUFFIX}"
    "proxy${SUFFIX}"
    "db${SUFFIX}"
    "testuser"
    "testpassword"
    "postgrest${SUFFIX}"
    "dialog${SUFFIX}"
    "4443"
    "thumbnail${SUFFIX}"
)

array_length=${#SOURCE[@]}

for ((i=0; i<array_length; i++)); do
    export ${SOURCE[i]}=${TARGET[i]}
done

function replace_vars_in_files() {
    FILE=$1

    for ((i=0; i<array_length; i++)); do
        # ESCAPED_DIR="${CURRENT_DIR//\//\\/}"
        # 문자열 내에 /를 \/로 변환한다.
        sed -i "s/\${${SOURCE[i]}}/${TARGET[i]//\//\\/}/g" $FILE
    done
}

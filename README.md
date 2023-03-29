# hubs-all-in-one

## 설정

웹브라우저를 실행하는 PC에 아래와 같이 도메인을 등록해야 한다.

```bash
echo "127.0.0.1 $DOMAIN" | sudo tee -a /etc/hosts >/dev/null"
```

## 빌드

MIX_ENV=prod mix compile
MIX_ENV=prod mix phx.digest
PORT=80 MIX_ENV=prod elixir -pa \_build/prod/consolidated -S mix phx.server

docker build -t reticulum .
docker run --rm --name reticulum -it -v $(pwd)/reticulum:/reticulum -w /reticulum reticulum bash

## generate perms key

openssl genrsa -out perms.priv.pem 1024
openssl rsa -in perms.prv.pem -pubout -out perms.pub.pem

## generate ssl certs

**self-signed cert는 사용하지 않는다. 테스트 도메인을 만들어서 실제 인증서를 사용한다.**

## 참고

- https://github.com/albirrkarim/mozilla-hubs-installation-detailed

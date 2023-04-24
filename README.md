# hubs-all-in-one

mozilla hubs를 단일 호스트에서 실행하는 예제

릴리즈 빌드
- hubs

사용하지 않음
- thumbnail - 돌아갈 것 같기는 한데 서비스들이 호출하지 않는다.



## 요구사항

1. ssl 인증서나 도메인 등 설정이 변경되면 .env를 변경해야 한다.
1. ssl 인증서는 체인 인증서(중간 인증서)를 포함하는 unified.crt 인증서를 사용해야 한다.
1. 도메인과 ssl 인증서\
    hosts에 도메인을 등록해서 설정하는 것은 까다롭고 프록시 서버 설정에서 문제가 있기 때문에 여기서는 사용하지 않는다.
1. perms 키 생성\
    reticulum과 postgrest에서 사용하는 인증서를 생성해야 한다.
    ```sh
    sh certs/keygen/run.sh
    ```
1. ssl인증서의 기간이 남아있는지 검증해야 한다.\
    ```sh
    sh certs/check_cert_expiration.sh
    ```

## 설정
1. .env 변경
1. postgrest/postgrest.conf db설정 변경해야 한다.
1. reticulum-ex/dev.exs에서 5,6번째 라인 수정
    ```
    host = "hubs1.vevv.io"
    cors_proxy_host = "proxy1.vevv.io"
    ```
1. nginx.conf 20번째 라인
    ```
    server_name proxy1.vevv.io;
    ```

## 빌드

요구사항을 모두 갖추면 다음의 순서로 스크립트를 실행한다.
`빌드 결과물은 모두 docker image다`

1. dialog 이미지 생성
    ```sh
    sh dialog-ex/build.sh
    ```
1. postgrest 이미지 생성
    ```sh
    sh postgrest/build.sh
    ```
1. hubs 이미지 생성
    ```sh
    sh hubs-ex/build.sh
    ```
1. reticulum 이미지 생성
    ```sh
    sh reticulum-ex/build.sh
    ```


## 실행
여러 프로젝트를 동시에 실행하면 `ENOSPC: System limit for number of file watchers reached`에러가 발생할 수 있다.
리눅스라면 아래와 같이 설정한다.
```sh
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
```

1. sh db/run.sh
1. sh dialog-ex/run.sh
1. sh hubs-ex/run-admin.sh
1. sh hubs-ex/run-front.sh
1. sh postgrest/run.sh
1. sh reticulum-ex/run.sh
1. sh proxy/run.sh

## 실행 후
1. db에서 isAdmin = true
    docker exec db psql -U postgres -d ret_dev -c "UPDATE accounts SET is_admin = true;"


## 참고
- https://github.com/albirrkarim/mozilla-hubs-installation-detailed

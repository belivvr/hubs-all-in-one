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


# NCLOUD에서 셋팅하는 방법(외부DB, NAS 사용)
NCLOUD에서 사용하기위해서 DB 서버, NAS 서버를 미리 만들어 준다.
1.postgres 서버
![image](https://github.com/belivvr/hubs-all-in-one/assets/59630175/6c610080-b8dd-4010-9b13-6afccf87687a)
- root로 ssh접속 후 sudo -su postgres 로 접속.
- psql로 postgresql 접속.
- CREATE USER [사용할 id] PASSWORD '[사용할 비밀번호]' SUPERUSER;
- CREATE DATABASE "ret_dev";

2.nas 서버
![image](https://github.com/belivvr/hubs-all-in-one/assets/59630175/de1b9ceb-89d8-49d2-8925-2bf950c36a5d)



1.유저를 만들고 sudo권한을 주고 사용자를 변경한다.
 ```sh
   sudo adduser [사용자명]
   sudo usermod -aG sudo [사용자명]
   sudo -su [사용자명]
 ```
2.git을 설치한다.
```sh
    sudo apt-get update
    sudo apt-get install git
```
3.docker를 설치한다.
```sh
    sudo apt-get update
    sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo groupadd docker
    sudo usermod -aG docker ${USER}
    sudo service docker restart
```
#참고
만약 docker ps가 권한 오류가 날 경우 세션을 재시작하거나 root로 바꾼 후 다시 접속한다.
```sh
    sudo -su root
    sudo -su [사용자명]
```
4.hubs-all-in-one을 다운 받는다.
```sh
    git clone https://github.com/belivvr/hubs-all-in-one.git
```

5.env.sh에서 만든 NAS 서버와 DB 서버의 정보로 바꾸어 준다.

참고
![image](https://github.com/belivvr/hubs-all-in-one/assets/59630175/2f7388db-b433-4c49-9820-86cc8f010c8e)
해당 설정에 맞에 레코드를 설정해 주어야한다.

6.NAS를 마운트한다.
```sh
    sudo apt-get install nfs-common
    sudo systemctl start rpcbind.service
    sudo systemctl enable rpcbind.service
    sudo mkdir /storage
    mount -t nfs [마운트 정보 ex)169.254.84.53:/n3048487_xrcloudRestore] /storage
```
7.NAS를 재부팅시에도 연결되도록 설정한다.
nano /etc/fstab
아래를 추가
```sh
[마운트 정보 ex)169.254.84.53:/n3048487_xrcloudRestore] /storage nfs vers=3,defaults 0 0
```


## TODO
Spoke nginx로 실행
reticulum release실행

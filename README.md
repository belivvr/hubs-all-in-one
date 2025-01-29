# hubs-all-in-one
BELIVVR 에서 만든 hubs프로젝트를 단일 호스트에서 실행하는 프로젝트

본 메뉴얼은 작업중으로 이후 영문으로 번역하고 정리할 예정입니다.

## 요구사항
1. docker
2. git

## 설정

인증서와 환경 설정을 변경해야 한다.
1. env.template 파일을 참고하여 .env 파일을 생성한다.

2. 1년에 한 번 reticulum과 postgrest에서 사용하는 인증서(perms)를 재생성해야 한다.
    ```sh
    sh certs/keygen/run.sh
    ```

## 실행

```sh
# 실행 권한 부여
chmod +x rebuild_all.sh

# 빌드 및 실행 방법
# 1. 전체 서비스(hubs + dialog) 실행
./rebuild_all.sh .env

# 2. hubs 관련 서비스만 실행
./rebuild_all.sh .env hubs

# 3. dialog 서비스만 실행
./rebuild_all.sh .env dialog
```

### 참고사항
- hubs 프로젝트와 dialog 프로젝트를 모두 실행하고 싶은 경우는 option을 생략한다.
- hubs와 dialog 프로젝트를 별개로 실행하여 두대를 운용할 수 있도록 두개의 옵션이 분리되어있다.
- .env 파일의 dialog_host 값을 변경하여 두대를 따로 운용하여 사용자 증가에 따른 webrtc서버의 부하를 다른 서버로 분리했다.
- dialog 서버의 수평확장에 대해서는 고려하지 않았다.

### Admin 계정 설정
본 프로젝트는 xrcloud와 연동하여 운용하는 것을 가정하고 있어 xrcloud-backend 프로젝트에서 사용하는 admin계정을 할당한다.
레티큘럼서버로 진입하여 xrcloud-backend 프로젝트에서 사용하는 admin계정을 입력하면 별도의 패스워드 없이 로그인된다.

이후 아래의 명령어로 hubs의 멤버를 admin으로 만든다.
```sh
# 주의! 아래 명령은 모든 멤버를 admin으로 만든다.
docker exec db psql -U postgres -d ret_dev -c "UPDATE accounts SET is_admin = true;"
```

이후 레티큘럼 서버에 직접 로그인하는 페이지는 막아서 새로운 계정을 직접 만들 수 없게 한다.



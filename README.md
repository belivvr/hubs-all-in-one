# hubs-all-in-one

mozilla hubs를 단일 호스트에서 실행하는 프로젝트

## 요구사항

1. docker
2. git

## 설정

인증서와 환경 설정을 변경해야 한다.

1. env.sh
1. certs/

> 1년에 한 번 reticulum과 postgrest에서 사용하는 인증서(perms)를 재생성해야 한다.
>
>    ```sh
>    sh certs/keygen/run.sh
>    ```

## 실행

```sh
# prod가 아닌 경우
bash reset_all.sh
# prod인 경우
bash reset_all.sh prod
```

## 실행 후
1. `dev_team@belivvr.com`을 가입하고 admin으로 만들어야 한다.
    ```sh
    # 주의! 아래 명령은 모든 멤버를 admin으로 만든다.
    docker exec db psql -U postgres -d ret_dev -c "UPDATE accounts SET is_admin = true;"
    ```

## NCLOUD 설정

1. NCLOUD에서 사용하기위해서 DB NAS, 레티큘럼 Storage용 NAS를 미리 만들어 준다.
![image](/docs/259619993-78617a1e-a427-447c-9838-491ceb217da8.png)

3.env.sh의 설정에 맞게 GlobalDNS에 레코드를 추가해준다.

```sh
# env.sh
HUBS_HOST="hubs.dev.belivvr.com"
DIALOG_HOST="hubs.dev.belivvr.com"
```

![image](/docs/261252110-30756760-82e4-43fa-a02d-8bba303f7380.png)

4.아래와 같이 ACG를 설정해준다.

> 아래 인바운드에서 `223.130.138.151`을 조심해라. 보안을 위해서 접근IP를 설정했다. 이것 때문에 ACG를 공유하면 동작하지 않는다.

인바운드

|종류|접근 소스|포트|설명|
|------|---|---|---|
TCP|223.130.138.151/32|5432|postgres
TCP|223.130.138.151/32|3000|postgrest
TCP|0.0.0.0/0|4000|Reticulum
TCP|0.0.0.0/0|4443|Mediasoup
TCP|0.0.0.0/0|40000-49999|Mediasoup
UDP|0.0.0.0/0|40000-49999|Mediasoup
TCP|0.0.0.0/0|4080|Proxy
TCP|0.0.0.0/0|8989|Admin
TCP|0.0.0.0/0|9090|Spoke
TCP|0.0.0.0/0|8080|Client

아웃바운드
|종류|접근 소스|포트|
|------|---|---|
TCP|0.0.0.0/0|1-65535
UDP|0.0.0.0/0|1-65535

![Alt text](/docs/haio_acg.png)

5.env.sh에서 만든 NAS 정보를 넣어 준다.
```sh
    ...
    DB_VOLUME_DIR="/data/postgres"
    DB_NAS_LOCATION="169.254.84.53:/n3048487_testNasDB"
    RETICULUM_STORAGE_DIR="/storage"
    STORAGE_NAS_LOCATION="169.254.84.53:/n3048487_testStorage"
    ...
```
6.NAS를 적용할 경우 prod 옵션을 추가해서 reset_all을 실행 시킨다.
```sh
    bash reset_all.sh prod
```

## 백업

1. storage 백업

    ```sh
    #ssh에서
    sudo tar -czvf storage.tar.gz /storage
    #sftp에서
    get storage.tar.gz /Users/hunjuly/Downloads/storage.tar.gz
    ```

2. storage 복원
    ```sh
    #sftp에서
    put /Users/hunjuly/Downloads/storage.tar.gz storage.tar.gz
    #ssh에서
    tar -xzvf storage.tar.gz -C /
    ```

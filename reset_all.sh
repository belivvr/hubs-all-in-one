docker rm -f postgrest
docker rm -f dialog
docker rm -f proxy
docker rm -f reticulum
docker rm -f client
docker rm -f admin
docker rm -f db
docker rm -f spoke
docker rm -f thumbnail

docker volume ls -q | xargs docker volume rm

bash dialog-ex/build.sh
bash postgrest/build.sh
bash hubs-ex/build.sh
bash spoke-ex/build.sh
bash thumbnail/build.sh
bash reticulum-ex/build.sh

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

bash db/run.sh
bash dialog-ex/run.sh
bash hubs-ex/run-admin.sh
bash hubs-ex/run-client.sh
bash spoke-ex/run.sh
bash postgrest/run.sh
bash reticulum-ex/run.sh
bash proxy/run.sh
bash thumbnail/run.sh

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

sh dialog-ex/build.sh
sh postgrest/build.sh
sh hubs-ex/build.sh
sh spoke-ex/build.sh
sh thumbnail/build.sh
sh reticulum-ex/build.sh

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

sh db/run.sh
sh dialog-ex/run.sh
sh hubs-ex/run-admin.sh
sh hubs-ex/run-client.sh
sh spoke-ex/run.sh
sh postgrest/run.sh
sh reticulum-ex/run.sh
sh proxy/run.sh
sh thumbnail/run.sh

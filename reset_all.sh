docker rm -f postgrest
docker rm -f dialog
docker rm -f proxy
docker rm -f reticulum
docker rm -f hubs-front
docker rm -f hubs-admin
docker rm -f db.vevv.io

docker rmi postgrest
docker rmi dialog
docker rmi nginx:stable-alpine
docker rmi reticulum
docker rmi hubs
docker rmi hubs
docker rmi postgres:11-bullseye

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi
docker volume ls -q | xargs docker volume rm

docker system prune -f

sh dialog-ex/build.sh
sh postgrest/build.sh
sh hubs-ex/build.sh
sh reticulum-ex/build.sh

sh db/run.sh
sh dialog-ex/run.sh
sh hubs-ex/run-admin.sh
sh hubs-ex/run-front.sh
sh postgrest/run.sh
sh reticulum-ex/run.sh
sh proxy/run.sh

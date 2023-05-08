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

# 이거 안 하면 temp 파일이 많이 쌓인다.
docker system prune -f

rm -rf dialog-ex/dialog
rm -rf hubs-ex/hubs
rm -rf reticulum-ex/reticulum
rm -rf spoke-ex/Spoke
rm -rf thumbnail/nearspark

docker images -a | grep "<none>" | awk '{print $3}' | xargs docker rmi

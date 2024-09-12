docker rm -f client
docker rmi -f client
bash hubs/build.sh
bash hubs/run.sh
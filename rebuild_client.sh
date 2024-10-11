docker rm -f client 
docker rmi -f client
bash hubs/build.sh $1
bash hubs/run.sh $1
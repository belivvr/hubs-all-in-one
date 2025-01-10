docker rm -f reticulum 
docker rmi -f reticulum
bash ./reticulum/build.sh dev
bash ./reticulum/run.sh dev
docker logs -f reticulum
#!/bin/bash
docker build -t ee-configure docker/ee-config/.
PWD=$(pwd)
docker run --rm --env-file .env -v $PWD/assets/:/assets -it ee-configure
docker rmi ee-configure

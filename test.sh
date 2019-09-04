#!/bin/bash
#
# Test the running elexis-environment installation
#
docker build -t ee-test docker/ee-test/.
docker run --rm --network="host" --env-file .env -it ee-test
docker rmi ee-test

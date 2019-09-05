#!/bin/bash
docker exec elexis-environment_mongo_1 sh -c 'exec mongodump --archive' > $PWD/mongodb-all-collections.archive
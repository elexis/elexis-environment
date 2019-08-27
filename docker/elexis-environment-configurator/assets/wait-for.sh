#!/bin/sh
# wait-for.sh
# Wait for RocketChat to become ready and
# perform initialisation. Rocketchat takes way longer
# so we stick with it

set -e

cmd="$@"

sleep 15

until curl -s -f "http://rocketchat:3000/chat/api/info"; do
  >&2 echo "Sleeping 5 seconds ...."
  sleep 5
done

>&2 echo "Ready."
exec $cmd


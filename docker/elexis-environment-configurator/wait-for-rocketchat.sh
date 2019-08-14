#!/bin/sh
# wait-for-rocketchat.sh

set -e

host="$1"
shift
cmd="$@"

sleep 15

until curl -s -f "$host"; do
  >&2 echo "Rocketchat is unavailable - sleeping"
  sleep 5
done

>&2 echo "Rocketchat is up - executing command"
exec $cmd


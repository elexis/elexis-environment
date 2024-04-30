#!/bin/sh
fping -l -i 5000 10.100.0.1 |  while IFS= read -r line
do
	echo "$line" > /tmp/fping.log
done
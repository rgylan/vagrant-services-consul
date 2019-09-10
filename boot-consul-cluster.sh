#!/bin/bash

sudo consul agent -server -bootstrap-expect=2 -data-dir=/tmp/consul -node=agent-server -bind=172.42.42.101 -enable-script-checks=true -config-dir=/etc/consul.d/ >> /var/log/consul/output.log &
STATUS=`curl --silent http://localhost:8500/v1/status/leader`
COUNT=1
while [ $COUNT -le 5 ] && [ "$STATUS" = "" ]
do
	COUNT=$(( COUNT+1 ))
	STATUS=`curl --silent http://localhost:8500/v1/status/leader`
	sleep 1
done
# Join another server
sudo consul join 172.42.42.102
# Join clients
sudo consul join 172.42.42.103
sudo consul join 172.42.42.104

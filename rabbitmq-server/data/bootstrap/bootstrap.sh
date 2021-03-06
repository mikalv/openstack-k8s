#!/usr/bin/env bash

source /bootstrap/functions.sh
get_environment

echo $RABBIT_COOKIE > /var/lib/rabbitmq/.erlang.cookie 
chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie 
chmod 400 /var/lib/rabbitmq/.erlang.cookie 

rabbitmq-server -detached 
sleep 6

rabbitmqctl add_user $RABBIT_USERID $RABBIT_PASSWORD
rabbitmqctl set_user_tags $RABBIT_USERID administrator 
rabbitmqctl set_permissions -p / $RABBIT_USERID  ".*" ".*" ".*" 

rabbitmqctl delete_user guest
rabbitmqctl stop
sleep 4

echo "*** User creation completed. ***"
echo "*** Log in the WebUI at port 15672 ***"

ulimit -S -n 65536
rabbitmq-server


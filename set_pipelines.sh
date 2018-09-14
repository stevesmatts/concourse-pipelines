#!/usr/bin/env bash

fly -t mirror sp -n -p mattermost -c pipelines/mattermost.yml --load-vars-from credentials.yml
fly -t mirror up -p mattermost

fly -t mirror sp -n -p rabbitmq -c pipelines/rabbitmq.yml --load-vars-from credentials.yml
fly -t mirror up -p rabbitmq

fly -t mirror sp -n -p tools -c pipelines/tools.yml --load-vars-from credentials.yml
fly -t mirror up -p tools

fly -t mirror sp -n -p memcache -c pipelines/memcache.yml --load-vars-from credentials.yml
fly -t mirror up -p memcache

fly -t mirror sp -n -p mysql -c pipelines/mysql.yml --load-vars-from credentials.yml
fly -t mirror up -p mysql
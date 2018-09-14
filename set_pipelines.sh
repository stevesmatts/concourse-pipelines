#!/usr/bin/env bash

fly -t mirror sp -n -p mattermost -c pipelines/mattermost.yml --load-vars-from credentials.yml
fly -t mirror up -p mattermost

fly -t mirror sp -n -p rabbitmq -c pipelines/rabbitmq.yml --load-vars-from credentials.yml
fly -t mirror up -p rabbitmq
#!/usr/bin/env bash

fly -t mirror sp -p mattermost -c pipelines/mattermost.yml --load-vars-from credentials.yml
fly -t mirror up -p mattermost
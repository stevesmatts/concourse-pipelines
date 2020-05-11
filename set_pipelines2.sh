#!/usr/bin/env bash

set -e
set -o pipefail

CREDENTIAL_FILE=credentials.yml

if [[ "$#" -eq 1 ]]; then
  TARGET=$1
else
  printf "Defaulting to target: mirror\n"
  TARGET=mirror
fi

if ! command -v fly > /dev/null 2>&1; then
  echo "fly must be installed before running this script!"
  exit 1
fi

fly -t ${TARGET} set-pipeline -n -p buildpacks -c pipelines/buildpacks.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p cf -c pipelines/cf.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p common -c pipelines/common.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p concourse -c pipelines/concourse.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p director -c pipelines/director.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p doomsday -c pipelines/doomsday.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p logsearch -c pipelines/logsearch.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p mattermost -c pipelines/mattermost.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p minio -c pipelines/minio.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p mysql -c pipelines/mysql.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p rabbitmq -c pipelines/rabbitmq.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p redis -c pipelines/redis.yml --load-vars-from credentials.yml
fly -t ${TARGET} set-pipeline -n -p test-deployment -c pipelines/test-deployment.yml --load-vars-from credentials.yml

fly -t ${TARGET} unpause-pipeline --all

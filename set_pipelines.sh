#!/usr/bin/env bash

set -e
set -o pipefail

CREDENTIAL_FILE=credentials.yml
DEFAULT_PARAMETERS=default_parameters.yml

if [[ "$#" -eq 1 ]]; then
  TARGET=$1
else
  printf "Defaulting to target: mirror\n"
  TARGET=mirror
fi

if ! command -v fly >/dev/null 2>&1; then
  echo "fly must be installed before running this script!"
  exit 1
fi

configure_pipeline() {
  NAME=$1
  CONFIG_FILE=$2

  printf "Setting pipeline: %s\n" ${NAME}
  fly -t ${TARGET} set-pipeline -n -p ${NAME} -c ${CONFIG_FILE} --load-vars-from ${DEFAULT_PARAMETERS} --load-vars-from ${CREDENTIAL_FILE}
  fly -t ${TARGET} unpause-pipeline -p ${NAME} >/dev/null
}

configure_pipeline buildpacks pipelines/buildpacks.yml
configure_pipeline cf pipelines/cf.yml
configure_pipeline common pipelines/common.yml
configure_pipeline concourse pipelines/concourse.yml
configure_pipeline director pipelines/director.yml
configure_pipeline doomsday pipelines/doomsday.yml
configure_pipeline logsearch pipelines/logsearch.yml
configure_pipeline mattermost pipelines/mattermost.yml
configure_pipeline minio pipelines/minio.yml
configure_pipeline mysql pipelines/mysql.yml
configure_pipeline postgres-cluster pipelines/postgres-cluster.yml
configure_pipeline prometheus pipelines/prometheus.yml
configure_pipeline rabbitmq pipelines/rabbitmq.yml
configure_pipeline redis pipelines/redis.yml
configure_pipeline test-deployment pipelines/test-deployment.yml

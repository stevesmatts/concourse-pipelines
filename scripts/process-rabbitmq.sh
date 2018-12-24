#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
RABBIT_SOURCE=$2
RABBIT_BROKER_SOURCE=$3
CF_CLI_SOURCE=$4
OUTPUT_DIRECTORY=$5

source ${BOSH_IO_SCRIPT} ${RABBIT_SOURCE} ${OUTPUT_DIRECTORY} cf-rabbitmq-release
source ${BOSH_IO_SCRIPT} ${RABBIT_BROKER_SOURCE} ${OUTPUT_DIRECTORY} cf-rabbitmq-multitenant-broker-release
source ${BOSH_IO_SCRIPT} ${CF_CLI_SOURCE} ${OUTPUT_DIRECTORY} cf-cli-release

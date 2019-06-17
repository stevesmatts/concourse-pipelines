#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
RABBIT_SOURCE=$2
RABBIT_BROKER_SOURCE=$3
RABBIT_SMOKE_TESTS=$4
CF_CLI_SOURCE=$5
ROUTING=$6
BPM=$7
OUTPUT_DIRECTORY=$5

source ${BOSH_IO_SCRIPT} ${RABBIT_SOURCE} ${OUTPUT_DIRECTORY} cf-rabbitmq-release
source ${BOSH_IO_SCRIPT} ${RABBIT_BROKER_SOURCE} ${OUTPUT_DIRECTORY} cf-rabbitmq-multitenant-broker-release
source ${BOSH_IO_SCRIPT} ${RABBIT_SMOKE_TESTS} ${OUTPUT_DIRECTORY} cf-rabbitmq-smoke-tests-release
source ${BOSH_IO_SCRIPT} ${CF_CLI_SOURCE} ${OUTPUT_DIRECTORY} cf-cli-release
source ${BOSH_IO_SCRIPT} ${ROUTING} ${OUTPUT_DIRECTORY} cf-routing-release
source ${BOSH_IO_SCRIPT} ${BPM} ${OUTPUT_DIRECTORY} bpm-release

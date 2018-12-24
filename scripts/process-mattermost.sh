#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
MATTERMOST_SOURCE=$2
OUTPUT_DIRECTORY=$3

source ${BOSH_IO_SCRIPT} ${MATTERMOST_SOURCE} ${OUTPUT_DIRECTORY} mattermost-boshrelease

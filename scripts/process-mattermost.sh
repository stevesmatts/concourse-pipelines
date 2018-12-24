#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
MATTERMOST_RELEASE=$2
OUTPUT_DIRECTORY=$3

echo Processing ${MATTERMOST_RELEASE}
source ${BOSH_IO_SCRIPT} ${MATTERMOST_RELEASE} ${OUTPUT_DIRECTORY} ${MATTERMOST_RELEASE}
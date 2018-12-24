#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
MEMCACHE_SOURCE=$2
OUTPUT_DIRECTORY=$3

source ${BOSH_IO_SCRIPT} ${MEMCACHE_SOURCE} ${OUTPUT_DIRECTORY} memcache-release

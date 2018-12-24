#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
MYSQL_SOURCE=$2
OUTPUT_DIRECTORY=$3

source ${BOSH_IO_SCRIPT} ${MYSQL_SOURCE} ${OUTPUT_DIRECTORY} cf-mysql-release

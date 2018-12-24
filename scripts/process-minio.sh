#!/usr/bin/env bash

set -e
set -o pipefail

BOSH_IO_SCRIPT=$1
MINIO_SOURCE=$2
OUTPUT_DIRECTORY=$3

source ${BOSH_IO_SCRIPT} ${MINIO_SOURCE} ${OUTPUT_DIRECTORY} minio-boshrelease

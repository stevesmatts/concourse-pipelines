#!/usr/bin/env bash

set -e
set -o pipefail

OUTPUT_DIRECTORY=$1

mkdir -p ${OUTPUT_DIRECTORY}
find . -type f -name '*.zip' -print -exec mv -t ./${OUTPUT_DIRECTORY}/ {} \+

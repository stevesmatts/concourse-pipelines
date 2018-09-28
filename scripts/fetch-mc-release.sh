#!/usr/bin/env bash

set -e

OUTPUT_FOLDER=$1

pushd ${OUTPUT_FOLDER}
curl -LOJ "https://dl.minio.io/client/mc/release/linux-amd64/mc"
popd
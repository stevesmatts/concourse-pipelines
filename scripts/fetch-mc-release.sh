#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
VERSION=$(cat ${SOURCE_FOLDER}/version)

curl -Lo ${OUTPUT_FOLDER}/mc-${VERSION} "https://dl.minio.io/client/mc/release/linux-amd64/mc"
if [ -f ${SOURCE_FOLDER}/body ]; then
  cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/mc-${VERSION}-release.md
fi
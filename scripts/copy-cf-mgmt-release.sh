#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
VERSION=$(cat ${SOURCE_FOLDER}/version)

cp ${SOURCE_FOLDER}/cf-mgmt-config-linux ${OUTPUT_FOLDER}/cf-mgmt-config-linux-${VERSION}
cp ${SOURCE_FOLDER}/cf-mgmt-linux ${OUTPUT_FOLDER}/cf-mgmt-linux-${VERSION}
cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/cf-mgmt-${VERSION}-release.md
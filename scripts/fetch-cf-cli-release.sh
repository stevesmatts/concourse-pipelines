#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
VERSION=$(cat ${SOURCE_FOLDER}/version)

cd ${OUTPUT_FOLDER}
curl -LO https://packages.cloudfoundry.org/stable?release=redhat64&version=${VERSION}&source=github-rel
cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/cf-cli-${VERSION}-release.md
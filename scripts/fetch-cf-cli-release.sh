#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
VERSION=$(cat ${SOURCE_FOLDER}/version)

curl -Lo ${OUTPUT_FOLDER}/cf-cli-installer_${VERSION}_x86-64.rpm "https://packages.cloudfoundry.org/stable?release=redhat64&version=${VERSION}&source=github-rel"
curl -Lo ${OUTPUT_FOLDER}/cf-cli-installer_${VERSION}_winx64.zip "https://packages.cloudfoundry.org/stable?release=windows64&version=${VERSION}&source=github-rel"
cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/cf-cli-${VERSION}-release.md
#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
ARTIFACT=$3

echo Processing ${ARTIFACT}
cp ${SOURCE_FOLDER}/$3* ${OUTPUT_FOLDER}/.
if [ -f ${SOURCE_FOLDER}/body ]; then
  echo Processing ${ARTIFACT} release notes
  cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/${ARTIFACT}-$(cat ${SOURCE_FOLDER}/version)-release.md
fi

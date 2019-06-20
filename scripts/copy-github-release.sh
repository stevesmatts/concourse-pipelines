#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
ARTIFACT=$3

echo Processing ${ARTIFACT}

if [[ -n "$4" ]]; then
  OUTPUT_FOLDER=${OUTPUT_FOLDER}/${ARTIFACT}/$(cat ${SOURCE_FOLDER}/version)
  mkdir -p ${OUTPUT_FOLDER}
fi

cp ${SOURCE_FOLDER}/$3* ${OUTPUT_FOLDER}/.
if [[ -f ${SOURCE_FOLDER}/body ]]; then
  echo Processing ${ARTIFACT} release notes
  if [[ -n "$4" ]]; then
    cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/release.md
  else
    cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/${ARTIFACT}-$(cat ${SOURCE_FOLDER}/version)-release.md
  fi
fi

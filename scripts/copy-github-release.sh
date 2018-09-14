#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2
ARTIFACT=$3

cp ${SOURCE_FOLDER}/$3* ${OUTPUT_FOLDER}/.
cp ${SOURCE_FOLDER}/body ${OUTPUT_FOLDER}/${ARTIFACT}-$(cat ${SOURCE_FOLDER}/version).txt
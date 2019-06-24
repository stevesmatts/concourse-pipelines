#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2

echo Processing Stemcell $(cat ${SOURCE_FOLDER}/version)
cp ${SOURCE_FOLDER}/*.tgz ${OUTPUT_FOLDER}/.

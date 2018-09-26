#!/usr/bin/env bash

set -e

SOURCE_FOLDER=$1
OUTPUT_FOLDER=$2

cp ${SOURCE_FOLDER}/* ${OUTPUT_FOLDER}/.

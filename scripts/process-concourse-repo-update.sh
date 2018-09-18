#!/usr/bin/env bash

set -e

REPO_LOCATION=$1
OUTPUT_FOLDER=$2
FETCH_SCRIPT=$3

# Generate a manifest with all the required files
bosh int ${REPO_LOCATION}/cluster/concourse.yml \
  -o ${REPO_LOCATION}/versions.yml >> manifest.yml

source ${FETCH_SCRIPT} manifest.yml ${OUTPUT_FOLDER}
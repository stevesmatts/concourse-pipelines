#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
RELEASE_FOLDER=$3

echo Generate a manifest with all the required ops files
bosh int ${REPO_LOCATION}/cluster/concourse.yml \
  -l ${REPO_LOCATION}/versions.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER}

#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4

echo Generate a manifest with all the required ops files
bosh int ${REPO_LOCATION}/deployment/logsearch-deployment.yml \
  -o ${REPO_LOCATION}/deployment/operations/cloudfoundry.yml \
  -o ${OPS_FOLDER}/remove_bpm_release.yml \
  -o ${OPS_FOLDER}/remove_routing_release.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER} "-->"

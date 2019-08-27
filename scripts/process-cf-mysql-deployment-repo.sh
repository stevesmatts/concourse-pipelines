#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4

echo Generate a manifest with all the required ops files
bosh int ${REPO_LOCATION}/cf-mysql-deployment.yml \
  -o ${OPS_FOLDER}/remove_mysql_duplicates.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER} "-->"

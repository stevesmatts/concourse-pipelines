#!/usr/bin/env bash

set -e

REPO_LOCATION=$1
OUTPUT_FOLDER=$2
FETCH_SCRIPT=$3
OPS_FOLDER=$4
STEMCELL_FOLDER=$5

# Generate a manifest with all the required files
bosh int ${REPO_LOCATION}/cf-deployment.yml \
  -o ${REPO_LOCATION}/operations/enable-nfs-volume-service.yml \
  -o ${REPO_LOCATION}/operations/use-compiled-releases.yml \
  -o ${REPO_LOCATION}/operations/backup-and-restore/enable-backup-restore.yml \
  -o ${OPS_FOLDER}/remove_buildpacks.yml >> manifest.yml

source ${FETCH_SCRIPT} manifest.yml ${OUTPUT_FOLDER}

# Get the stemcell
STEMCELL_OS=$(bosh int manifest.yml --path /stemcells/alias=default/os)
STEMCELL_VERSION=$(bosh int manifest.yml --path /stemcells/alias=default/version)

pushd ${STEMCELL_FOLDER}
curl -LOJ https://bosh.io/d/stemcells/bosh-vsphere-esxi-${STEMCELL_OS}-go_agent?v=${STEMCELL_VERSION}
popd
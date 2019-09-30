#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
GIT_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4
STEMCELL_FOLDER=$5

echo Generate a manifest with all the required ops files
bosh int ${GIT_LOCATION}/cf-deployment.yml \
  -o ${GIT_LOCATION}/operations/enable-nfs-volume-service.yml \
  -o ${GIT_LOCATION}/operations/use-compiled-releases.yml \
  -o ${GIT_LOCATION}/operations/backup-and-restore/enable-backup-restore.yml \
  -o ${OPS_FOLDER}/remove_buildpacks.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER} "-->"

STEMCELL_OS=$(bosh int manifest.yml --path /stemcells/alias=default/os)
STEMCELL_VERSION=$(bosh int manifest.yml --path /stemcells/alias=default/version)

echo Fetching the stemcell ${STEMCELL_OS}/${STEMCELL_VERSION}

pushd ${STEMCELL_FOLDER} > /dev/null
curl --silent --retry 5 -Lo bosh-stemcell-${STEMCELL_VERSION}-vsphere-esxi-${STEMCELL_OS}-go_agent.tgz https://bosh.io/d/stemcells/bosh-vsphere-esxi-${STEMCELL_OS}-go_agent?v=${STEMCELL_VERSION}
popd > /dev/null
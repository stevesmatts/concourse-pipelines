#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
GITHUB_RELEASE_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4
STEMCELL_FOLDER=$5

echo Extracting source.tar.gz
tar xzf ${GITHUB_RELEASE_LOCATION}/source.tar.gz

echo Generate a manifest with all the required ops files
REPO_LOCATION=cloudfoundry-cf-deployment-$(cat ${GITHUB_RELEASE_LOCATION}/commit_sha | cut -c 1-7 )
bosh int ${REPO_LOCATION}/cf-deployment.yml \
  -o ${REPO_LOCATION}/operations/enable-nfs-volume-service.yml \
  -o ${REPO_LOCATION}/operations/use-compiled-releases.yml \
  -o ${REPO_LOCATION}/operations/backup-and-restore/enable-backup-restore.yml \
  -o ${OPS_FOLDER}/remove_buildpacks.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER}

if [ -f ${GITHUB_RELEASE_LOCATION}/body ]; then
  echo Copying release notes
  cp ${GITHUB_RELEASE_LOCATION}/body ${RELEASE_FOLDER}/cf-deployment-$(cat ${GITHUB_RELEASE_LOCATION}/version)-release.md
fi

STEMCELL_OS=$(bosh int manifest.yml --path /stemcells/alias=default/os)
STEMCELL_VERSION=$(bosh int manifest.yml --path /stemcells/alias=default/version)

echo Fetching the stemcell ${STEMCELL_OS}/${STEMCELL_VERSION}

pushd ${STEMCELL_FOLDER} > /dev/null
curl --silent -LOJ --retry 5 https://bosh.io/d/stemcells/bosh-vsphere-esxi-${STEMCELL_OS}-go_agent?v=${STEMCELL_VERSION}
popd > /dev/null

#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4
STEMCELL_FOLDER=$5

echo Generate a manifest with all the required ops files
bosh int ${REPO_LOCATION}/cf-mysql-deployment.yml \
  -o ${REPO_LOCATION}/operations/add-broker.yml \
  -o ${REPO_LOCATION}/operations/register-proxy-route.yml \
  -o ${REPO_LOCATION}/operations/configure-broker-load-balancer.yml \
  -o ${OPS_FOLDER}/remove_routing.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER}

STEMCELL_OS=$(bosh int manifest.yml --path /stemcells/alias=default/os)
STEMCELL_VERSION=$(bosh int manifest.yml --path /stemcells/alias=default/version)

echo Fetching the stemcell ${STEMCELL_OS}/${STEMCELL_VERSION}

pushd ${STEMCELL_FOLDER} > /dev/null
curl --silent --retry 5 -Lo bosh-stemcell-${STEMCELL_VERSION}-vsphere-esxi-${STEMCELL_OS}-go_agent.tgz https://bosh.io/d/stemcells/bosh-vsphere-esxi-${STEMCELL_OS}-go_agent?v=${STEMCELL_VERSION}
popd > /dev/null
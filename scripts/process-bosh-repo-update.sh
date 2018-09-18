#!/usr/bin/env bash

set -e

BOSH_REPO_LOCATION=$1
OUTPUT_FOLDER=$2
FETCH_SCRIPT=$3

# Generate a manifest with all the required files
bosh int ${BOSH_REPO_LOCATION}/bosh.yml \
  -o ${BOSH_REPO_LOCATION}/vsphere/cpi.yml \
  -o ${BOSH_REPO_LOCATION}/misc/dns.yml \
  -o ${BOSH_REPO_LOCATION}/misc/ntp.yml \
  -o ${BOSH_REPO_LOCATION}/uaa.yml \
  -o ${BOSH_REPO_LOCATION}/credhub.yml \
  -o ${BOSH_REPO_LOCATION}/jumpbox-user.yml \
  -o ${BOSH_REPO_LOCATION}/bbr.yml >> manifest.yml

source ${FETCH_SCRIPT} manifest.yml ${OUTPUT_FOLDER}

STEMCELL_URL=$(bosh int manifest.yml --path /resource_pools/name=vms/stemcell/url)

pushd ${OUTPUT_FOLDER}/stemcells
curl -LOJ ${STEMCELL_URL}
popd
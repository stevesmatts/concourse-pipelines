#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
RELEASE_FOLDER=$3
STEMCELL_FOLDER=$4
BOSH_IO_SCRIPT=$5
DNS_SOURCE=$6

echo Generate a manifest with all the required ops files
bosh int ${REPO_LOCATION}/bosh.yml \
  -o ${REPO_LOCATION}/vsphere/cpi.yml \
  -o ${REPO_LOCATION}/misc/dns.yml \
  -o ${REPO_LOCATION}/misc/ntp.yml \
  -o ${REPO_LOCATION}/uaa.yml \
  -o ${REPO_LOCATION}/credhub.yml \
  -o ${REPO_LOCATION}/jumpbox-user.yml \
  -o ${REPO_LOCATION}/bbr.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER}

STEMCELL_URL=$(bosh int manifest.yml --path /resource_pools/name=vms/stemcell/url)

pushd ${STEMCELL_FOLDER} > /dev/null
echo Fetching the stemcell ${STEMCELL_URL}
curl --silent -LOJ --retry 5 ${STEMCELL_URL}
popd > /dev/null

source ${BOSH_IO_SCRIPT} ${DNS_SOURCE} ${RELEASE_FOLDER} bosh-dns-release

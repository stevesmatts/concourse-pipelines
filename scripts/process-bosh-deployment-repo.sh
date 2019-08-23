#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4
STEMCELL_FOLDER=$5
BOSH_IO_SCRIPT=$6
DNS_SOURCE=$7

# VSPHERE DIRECTOR
echo Generate a manifest with all the required ops files for a vSphere director
bosh int ${REPO_LOCATION}/bosh.yml \
  -o ${REPO_LOCATION}/vsphere/cpi.yml \
  -o ${REPO_LOCATION}/misc/dns.yml \
  -o ${REPO_LOCATION}/misc/ntp.yml \
  -o ${REPO_LOCATION}/uaa.yml \
  -o ${REPO_LOCATION}/credhub.yml \
  -o ${REPO_LOCATION}/jumpbox-user.yml \
  -o ${REPO_LOCATION}/bbr.yml >> manifest.yml

echo Fetching releases
source ${FETCH_SCRIPT} manifest.yml ${RELEASE_FOLDER} "-->"

STEMCELL_URL=$(bosh int manifest.yml --path /resource_pools/name=vms/stemcell/url)

pushd ${STEMCELL_FOLDER} > /dev/null
echo Fetching the stemcell ${STEMCELL_URL}
curl --silent -LOJ --retry 5 ${STEMCELL_URL}
popd > /dev/null

# BOSH-LITE DIRECTOR
echo Generate a manifest with all the required ops files for a Bosh-Lite director
bosh int ${REPO_LOCATION}/bosh.yml \
  -o ${REPO_LOCATION}/virtualbox/cpi.yml \
  -o ${REPO_LOCATION}/bosh-lite.yml \
  -o ${OPS_FOLDER}/remove_boshlite_duplicates.yml >> manifest-lite.yml

echo Fetching bosh-lite only releases
source ${FETCH_SCRIPT} manifest-lite.yml ${RELEASE_FOLDER} "-->"

# BOSH DNS RELEASE
echo Fetching Bosh DNS addon release
source ${BOSH_IO_SCRIPT} ${DNS_SOURCE} ${RELEASE_FOLDER} bosh-dns-release "-->"

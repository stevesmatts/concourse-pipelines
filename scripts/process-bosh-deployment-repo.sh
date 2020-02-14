#!/usr/bin/env bash

set -e

FETCH_SCRIPT=$1
REPO_LOCATION=$2
OPS_FOLDER=$3
RELEASE_FOLDER=$4
STEMCELL_FOLDER=$5

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

DNS_URL=$(bosh int ${REPO_LOCATION}/runtime-configs/dns.yml --path /releases/name=bosh-dns/url)
pushd ${RELEASE_FOLDER} > /dev/null
echo "-->" Downloading artifact: ${DNS_URL}
curl --silent -LOJ --retry 5 ${DNS_URL}
popd > /dev/null

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
  -o ${OPS_FOLDER}/remove_bpm_release.yml \
  -o ${OPS_FOLDER}/remove_boshlite_duplicates.yml >> manifest-lite.yml

echo Fetching bosh-lite only releases
source ${FETCH_SCRIPT} manifest-lite.yml ${RELEASE_FOLDER} "-->"

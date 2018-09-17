#!/usr/bin/env bash

set -e

BOSH_REPO_LOCATION=$1
OUTPUT_FOLDER=$2

# Generate a manifest with all the required files
bosh int ${BOSH_REPO_LOCATION}/bosh.yml \
  -o ${BOSH_REPO_LOCATION}/vsphere/cpi.yml \
  -o ${BOSH_REPO_LOCATION}/misc/dns.yml \
  -o ${BOSH_REPO_LOCATION}/misc/ntp.yml \
  -o ${BOSH_REPO_LOCATION}/uaa.yml \
  -o ${BOSH_REPO_LOCATION}/credhub.yml \
  -o ${BOSH_REPO_LOCATION}/jumpbox-user.yml \
  -o ${BOSH_REPO_LOCATION}/bbr.yml >> manifest.yml

URLS="$(bosh int manifest.yml --path /releases | grep url | awk '{split($0,a,"url:"); print a[2]}')"

pushd ${OUTPUT_FOLDER}
for URL in ${URLS}
do
    curl -LO ${URL}
done
popd
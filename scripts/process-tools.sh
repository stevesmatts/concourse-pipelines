#!/usr/bin/env bash

set -e
set -o pipefail

GITHUB_RELEASE_SCRIPT=$1
BOSH_CLI_SOURCE=$2
BOSH_CLI_OUTPUT=bosh-cli
CREDHUB_CLI_SOURCE=$3
CREDHUB_CLI_OUTPUT=credhub-cli
BBR_CLI_SOURCE=$4
BBR_CLI_OUTPUT=bbr-cli
MC_CLI_SOURCE=$5
MC_CLI_OUTPUT=mc-cli
MC_CLI_VERSION=$(cat ${MC_CLI_SOURCE}/version)
CF_MGMT_CLI_SOURCE=$6
CF_MGMT_CLI_OUTPUT=cf-mgmt-cli
CF_MGMT_CLI_VERSION=$(cat ${CF_MGMT_CLI_SOURCE}/version)

# Process BOSH CLI
source ${GITHUB_RELEASE_SCRIPT} ${BOSH_CLI_SOURCE} ${BOSH_CLI_OUTPUT} bosh-cli

# Process CREDHUB CLI
source ${GITHUB_RELEASE_SCRIPT} ${CREDHUB_CLI_SOURCE} ${CREDHUB_CLI_OUTPUT} credhub

# Process BBR CLI
source ${GITHUB_RELEASE_SCRIPT} ${BBR_CLI_SOURCE} ${BBR_CLI_OUTPUT} bbr

# Process MC
echo Processing MC CLI ${MC_CLI_VERSION} windows and linux client
curl --silent --retry 5 -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION} "https://dl.minio.io/client/mc/release/linux-amd64/mc"
curl --silent --retry 5 -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION}.exe "https://dl.minio.io/client/mc/release/windows-amd64/mc.exe"
if [ -f ${MC_CLI_SOURCE}/body ]; then
  echo Processing MC CLI ${MC_CLI_VERSION} release notes
  cp ${MC_CLI_SOURCE}/body ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION}-release.md
fi

# Process CF-MGMT
echo Processing CF-MGMT CLI ${CF_MGMT_CLI_VERSION}
cp ${CF_MGMT_CLI_SOURCE}/cf-mgmt-config-linux ${CF_MGMT_CLI_OUTPUT}/cf-mgmt-config-linux-${CF_MGMT_CLI_VERSION}
cp ${CF_MGMT_CLI_SOURCE}/cf-mgmt-linux ${CF_MGMT_CLI_OUTPUT}/cf-mgmt-linux-${CF_MGMT_CLI_VERSION}
if [ -f ${CF_MGMT_CLI_SOURCE}/body ]; then
  echo Processing CF-MGMT CLI ${CF_MGMT_CLI_VERSION} release notes
  cp ${CF_MGMT_CLI_SOURCE}/body ${CF_MGMT_CLI_OUTPUT}/cf-mgmt-${CF_MGMT_CLI_VERSION}-release.md
fi

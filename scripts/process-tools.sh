#!/usr/bin/env bash

set -e
set -o pipefail

GITHUB_RELEASE_SCRIPT=$1
BOSH_CLI_SOURCE=$2
BOSH_CLI_OUTPUT=bosh-cli
CF_CLI_SOURCE=$3
CF_CLI_OUTPUT=cf-cli
CF_CLI_VERSION=$(cat ${CF_CLI_SOURCE}/version)
CREDHUB_CLI_SOURCE=$4
CREDHUB_CLI_OUTPUT=credhub-cli
BBR_CLI_SOURCE=$5
BBR_CLI_OUTPUT=bbr-cli
MC_CLI_SOURCE=$6
MC_CLI_OUTPUT=mc-cli
MC_CLI_VERSION=$(cat ${MC_CLI_SOURCE}/version)
CF_MGMT_CLI_SOURCE=$7
CF_MGMT_CLI_OUTPUT=cf-mgmt-cli
CF_MGMT_CLI_VERSION=$(cat ${CF_MGMT_CLI_SOURCE}/version)

# Process BOSH CLI
source ${GITHUB_RELEASE_SCRIPT} ${BOSH_CLI_SOURCE} ${BOSH_CLI_OUTPUT} bosh-cli

# Process CF CLI
echo Processing CF CLI ${CF_CLI_VERSION} windows and linux client
curl --silent -Lo ${CF_CLI_OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_x86-64.rpm "https://packages.cloudfoundry.org/stable?release=redhat64&version=${CF_CLI_VERSION}&source=github-rel"
curl --silent -Lo ${CF_CLI_OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_winx64.zip "https://packages.cloudfoundry.org/stable?release=windows64&version=${CF_CLI_VERSION}&source=github-rel"
if [ -f ${CF_CLI_SOURCE}/body ]; then
  echo Processing CF CLI ${CF_CLI_VERSION} release notes
  cp ${CF_CLI_SOURCE}/body ${CF_CLI_OUTPUT}/cf-cli-${CF_CLI_VERSION}-release.md
fi

# Process CREDHUB CLI
source ${GITHUB_RELEASE_SCRIPT} ${CREDHUB_CLI_SOURCE} ${CREDHUB_CLI_OUTPUT} credhub

# Process BBR CLI
source ${GITHUB_RELEASE_SCRIPT} ${BBR_CLI_SOURCE} ${BBR_CLI_OUTPUT} bbr

# Process MC
echo Processing MC CLI ${MC_CLI_VERSION} windows and linux client
curl --silent -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION} "https://dl.minio.io/client/mc/release/linux-amd64/mc"
curl --silent -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION}.exe "https://dl.minio.io/client/mc/release/windows-amd64/mc.exe"
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

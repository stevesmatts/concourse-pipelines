#!/usr/bin/env bash

set -e
set -o pipefail

MC_CLI_SOURCE=$1
MC_CLI_OUTPUT=$2
MC_CLI_VERSION=$(cat ${MC_CLI_SOURCE}/version)

echo Processing MC CLI ${MC_CLI_VERSION}
echo Downloading Linux client
curl --silent --retry 5 -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION} "https://dl.minio.io/client/mc/release/linux-amd64/mc"
echo Downloading Windows client
curl --silent --retry 5 -Lo ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION}.exe "https://dl.minio.io/client/mc/release/windows-amd64/mc.exe"
if [[ -f ${MC_CLI_SOURCE}/body ]]; then
  echo Processing MC CLI ${MC_CLI_VERSION} release notes
  cp ${MC_CLI_SOURCE}/body ${MC_CLI_OUTPUT}/mc-${MC_CLI_VERSION}-release.md
fi

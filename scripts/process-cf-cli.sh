#!/usr/bin/env bash

set -e
set -o pipefail

GITHUB_RELEASE_SCRIPT=$1
OUTPUT=$2
CF_CLI_SOURCE=$3
CF_CLI_VERSION=$(cat ${CF_CLI_SOURCE}/version)

# Process CF CLI
echo Processing CF CLI ${CF_CLI_VERSION} windows and linux client
curl --silent --retry 5 -Lo ${OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_x86-64.rpm "https://packages.cloudfoundry.org/stable?release=redhat64&version=${CF_CLI_VERSION}&source=github-rel"
curl --silent --retry 5 -Lo ${OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_winx64.zip "https://packages.cloudfoundry.org/stable?release=windows64&version=${CF_CLI_VERSION}&source=github-rel"
if [ -f ${CF_CLI_SOURCE}/body ]; then
  echo Processing CF CLI ${CF_CLI_VERSION} release notes
  cp ${CF_CLI_SOURCE}/body ${OUTPUT}/cf-cli-${CF_CLI_VERSION}-release.md
fi

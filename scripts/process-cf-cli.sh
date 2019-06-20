#!/usr/bin/env bash

set -e
set -o pipefail

CF_CLI_SOURCE=$1
CF_CLI_OUTPUT=$2
CF_CLI_VERSION=$(cat ${CF_CLI_SOURCE}/version)

# Process CF CLI
echo Processing CF CLI ${CF_CLI_VERSION} windows client
curl --silent --retry 5 -Lo ${CF_CLI_OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_x86-64.rpm "https://packages.cloudfoundry.org/stable?release=redhat64&version=${CF_CLI_VERSION}&source=github-rel"
echo Processing CF CLI ${CF_CLI_VERSION} linux client
curl --silent --retry 5 -Lo ${CF_CLI_OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_winx64.zip "https://packages.cloudfoundry.org/stable?release=windows64&version=${CF_CLI_VERSION}&source=github-rel"
if [[ -f ${CF_CLI_SOURCE}/body ]]; then
  echo Processing CF CLI ${CF_CLI_VERSION} release notes
  cp ${CF_CLI_SOURCE}/body ${CF_CLI_OUTPUT}/cf-cli--installer_${CF_CLI_VERSION}-release.md
fi

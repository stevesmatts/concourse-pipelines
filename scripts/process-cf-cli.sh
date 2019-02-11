#!/usr/bin/env bash

set -e
set -o pipefail

GITHUB_RELEASE_SCRIPT=$1
OUTPUT=$2
CF_CLI_SOURCE=$3
CF_CLI_VERSION=$(cat ${CF_CLI_SOURCE}/version)
ANTIFREEZE_SOURCE=$4
ANTIFREEZE_VERSION=$(cat ${ANTIFREEZE_SOURCE}/version)
AUTOPILOT_SOURCE=$5
AUTOPILOT_VERSION=$(cat ${AUTOPILOT_SOURCE}/version)
CF_BPCK_MNGT_SOURCE=$6
CF_BPCK_MNGT_VERSION=$(cat ${CF_BPCK_MNGT_SOURCE}/version)
CF_TOP_SOURCE=$7
CF_TOP_VERSION=$(cat ${CF_TOP_SOURCE}/version)

# Process CF CLI
echo Processing CF CLI ${CF_CLI_VERSION} windows client
curl --silent --retry 5 -Lo ${OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_x86-64.rpm "https://packages.cloudfoundry.org/stable?release=redhat64&version=${CF_CLI_VERSION}&source=github-rel"
echo Processing CF CLI ${CF_CLI_VERSION} linux client
curl --silent --retry 5 -Lo ${OUTPUT}/cf-cli-installer_${CF_CLI_VERSION}_winx64.zip "https://packages.cloudfoundry.org/stable?release=windows64&version=${CF_CLI_VERSION}&source=github-rel"
if [[ -f ${CF_CLI_SOURCE}/body ]]; then
  echo Processing CF CLI ${CF_CLI_VERSION} release notes
  cp ${CF_CLI_SOURCE}/body ${OUTPUT}/cf-cli-${CF_CLI_VERSION}-release.md
fi

mkdir ${OUTPUT}/plugins

# Process Antifreeze
echo Processing Antifreeze ${ANTIFREEZE_VERSION} windows client
cp ${ANTIFREEZE_SOURCE}/antifreeze.exe ${OUTPUT}/plugins/antifreeze-${ANTIFREEZE_VERSION}.exe
echo Processing Antifreeze ${ANTIFREEZE_VERSION} linux client
cp ${ANTIFREEZE_SOURCE}/antifreeze-linux ${OUTPUT}/plugins/antifreeze-linux-${ANTIFREEZE_VERSION}
if [[ -f ${ANTIFREEZE_SOURCE}/body ]]; then
  echo Processing Antifreeze ${ANTIFREEZE_VERSION} release notes
  cp ${ANTIFREEZE_SOURCE}/body ${OUTPUT}/plugins/antifreeze-${ANTIFREEZE_VERSION}-release.md
fi

# Process Autopilot
echo Processing Autopilot ${AUTOPILOT_VERSION} windows client
cp ${AUTOPILOT_SOURCE}/autopilot.exe ${OUTPUT}/plugins/autopilot-${AUTOPILOT_VERSION}.exe
echo Processing Autopilot ${AUTOPILOT_VERSION} linux client
cp ${AUTOPILOT_SOURCE}/autopilot-linux ${OUTPUT}/plugins/autopilot-linux-${AUTOPILOT_VERSION}
if [[ -f ${AUTOPILOT_SOURCE}/body ]]; then
  echo Processing Autopilot ${AUTOPILOT_VERSION} release notes
  cp ${AUTOPILOT_SOURCE}/body ${OUTPUT}/plugins/autopilot-${AUTOPILOT_VERSION}-release.md
fi

# Process CF-Buildpack-Management
echo Processing CF-Buildpack-Management ${CF_BPCK_MNGT_VERSION} windows client
cp ${CF_BPCK_MNGT_SOURCE}/cf-buildpack-management-plugin_windows_amd64.exe ${OUTPUT}/plugins/cf-buildpack-management-plugin_windows_amd64-${CF_BPCK_MNGT_VERSION}.exe
echo Processing CF-Buildpack-Management ${CF_BPCK_MNGT_VERSION} linux client
cp ${CF_BPCK_MNGT_SOURCE}/cf-buildpack-management-plugin_linux_amd64 ${OUTPUT}/plugins/cf-buildpack-management-plugin_linux_amd64-${CF_BPCK_MNGT_VERSION}
if [[ -f ${CF_BPCK_MNGT_SOURCE}/body ]]; then
  echo Processing CF-Buildpack-Management ${CF_BPCK_MNGT_VERSION} release notes
  cp ${CF_BPCK_MNGT_SOURCE}/body ${OUTPUT}/plugins/cf-buildpack-management-${CF_BPCK_MNGT_VERSION}-release.md
fi

# Process CF-Top
echo Processing CF-Top ${CF_TOP_VERSION} windows client
cp ${CF_TOP_SOURCE}/top-plugin64.exe ${OUTPUT}/plugins/top-plugin64-${CF_TOP_VERSION}.exe
echo Processing CF-Top ${CF_TOP_VERSION} linux client
cp ${CF_TOP_SOURCE}/top-plugin-linux64 ${OUTPUT}/plugins/top-plugin-linux64-${CF_TOP_VERSION}
if [[ -f ${CF_TOP_SOURCE}/body ]]; then
  echo Processing CF-Top ${CF_TOP_VERSION} release notes
  cp ${CF_TOP_SOURCE}/body ${OUTPUT}/plugins/top-${CF_TOP_VERSION}-release.md
fi

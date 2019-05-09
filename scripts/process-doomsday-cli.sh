#!/usr/bin/env bash

set -e
set -o pipefail

DOOMSDAY_CLI_SOURCE=$1
DOOMSDAY_CLI_OUTPUT=$2
DOOMSDAY_CLI_VERSION=$(cat ${DOOMSDAY_CLI_SOURCE}/version)

echo Processing Doomsday CLI ${DOOMSDAY_CLI_VERSION}
cp ${DOOMSDAY_CLI_SOURCE}/doomsday-linux ${DOOMSDAY_CLI_OUTPUT}/doomsday-linux-${DOOMSDAY_CLI_VERSION}

if [[ -f ${DOOMSDAY_CLI_SOURCE}/body ]]; then
  echo Processing Doomsday CLI ${DOOMSDAY_CLI_VERSION} release notes
  cp ${DOOMSDAY_CLI_SOURCE}/body ${DOOMSDAY_CLI_OUTPUT}/doomsday-${DOOMSDAY_CLI_VERSION}-release.md
fi

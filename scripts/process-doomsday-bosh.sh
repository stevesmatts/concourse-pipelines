#!/usr/bin/env bash

set -e
set -o pipefail

DOOMSDAY_BOSH_SOURCE=$1
DOOMSDAY_BOSH_OUTPUT=$2
DOOMSDAY_BOSH_VERSION=$(cat ${DOOMSDAY_BOSH_SOURCE}/version)

echo Processing Doomsday Bosh ${DOOMSDAY_BOSH_VERSION}
cp ${DOOMSDAY_BOSH_SOURCE}/doomsday-*.tgz ${DOOMSDAY_BOSH_OUTPUT}/.

if [[ -f ${DOOMSDAY_BOSH_SOURCE}/body ]]; then
  echo Processing Doomsday Bosh ${DOOMSDAY_BOSH_VERSION} release notes
  cp ${DOOMSDAY_BOSH_SOURCE}/body ${DOOMSDAY_BOSH_OUTPUT}/doomsday-${DOOMSDAY_BOSH_VERSION}-release.md
fi

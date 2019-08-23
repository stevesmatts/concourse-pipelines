#!/usr/bin/env bash

set -e

MANIFEST=$1
OUTPUT_FOLDER=$2
LOG_PREFIX=$3

URLS="$(bosh int ${MANIFEST} --path /releases | grep url | awk '{split($0,a,"url:"); print a[2]}')"

pushd ${OUTPUT_FOLDER} > /dev/null

for URL in ${URLS}
do
  echo ${LOG_PREFIX} Downloading artifact: ${URL}
  curl --silent -LOJ --retry 5 ${URL}
done
# Fix curl leaving url parameters in filename
if test -e `echo *.tgz\?* | cut -d' ' -f1`
then
  for file in *.tgz\?*; do mv "$file" "${file%%\?*}"; done
fi

popd > /dev/null

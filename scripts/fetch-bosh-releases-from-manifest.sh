#!/usr/bin/env bash

set -e
shopt -s nullglob

MANIFEST=$1
OUTPUT_FOLDER=$2

URLS="$(bosh int ${MANIFEST} --path /releases | grep url | awk '{split($0,a,"url:"); print a[2]}')"

pushd ${OUTPUT_FOLDER}
for URL in ${URLS}
do
    curl -LOJ ${URL}
done
# Fix curl leaving url parameters in filename
for file in *.tgz\?*; do mv "$file" "${file%%\?*}"; done
popd
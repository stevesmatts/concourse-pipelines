#!/usr/bin/env bash

set -e

MANIFEST=$1
OUTPUT_FOLDER=$2

URLS="$(bosh int ${MANIFEST} --path /releases | grep url | awk '{split($0,a,"url:"); print a[2]}')"

pushd ${OUTPUT_FOLDER}

for URL in ${URLS}
do
    curl -LOJ ${URL}
done
# Fix curl leaving url parameters in filename
if test -e `echo *.tgz\?* | cut -d' ' -f1`
then
    for file in *.tgz\?*; do mv "$file" "${file%%\?*}"; done
fi

popd
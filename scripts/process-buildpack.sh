#!/usr/bin/env bash

set -e
set -o pipefail

BUILDPACK=$1
GITHUB_REPO=$2
OUTPUT_FOLDER=$3
STACK=$4
BUILD_FOLDER=buildpack-source

echo Processing ${BUILDPACK} buildpack

go get github.com/cloudfoundry/libbuildpack/packager/buildpack-packager
mkdir ${BUILD_FOLDER}
tar -xzf ${GITHUB_REPO}/source.tar.gz --strip-components=1 -C ${BUILD_FOLDER}

pushd ${BUILD_FOLDER} > /dev/null

rm -f *.zip
source .envrc
buildpack-packager summary
buildpack-packager summary > release-packages.md
if [[ "$STACK" = "2" ]]; then
    echo Building cached buildpack for cflinuxfs2
    buildpack-packager build --cached --stack cflinuxfs2
elif [[ "$STACK" = "3" ]]; then
    echo Building cached buildpack for cflinuxfs3
    buildpack-packager build --cached --stack cflinuxfs3
elif [[ "$STACK" = "all" ]]; then
    echo Building cached buildpack for cflinuxfs2
    buildpack-packager build --cached --stack cflinuxfs2
    echo Building cached buildpack for cflinuxfs3
    buildpack-packager build --cached --stack cflinuxfs3
else
    echo Unsupported stack, must be '2', '3' or 'all'
    exit 1
fi

popd > /dev/null

mv ${BUILD_FOLDER}/release-packages.md ${OUTPUT_FOLDER}/${BUILDPACK}_buildpack-cached-$(cat ${GITHUB_REPO}/version)-release-packages.md
mv ${BUILD_FOLDER}/*.zip ${OUTPUT_FOLDER}

if [[ -f ${GITHUB_REPO}/body ]]; then
  echo Processing ${BUILDPACK} buildpack release notes
  cp ${GITHUB_REPO}/body ${OUTPUT_FOLDER}/${BUILDPACK}_buildpack-cached-$(cat ${GITHUB_REPO}/version)-release.md
fi

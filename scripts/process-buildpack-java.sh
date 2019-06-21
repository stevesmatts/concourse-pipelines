#!/usr/bin/env bash

set -e
set -o pipefail

BUILDPACK=$1
GITHUB_REPO=$2
OUTPUT_FOLDER=$3
STACK=$4
BUILD_FOLDER=buildpack-source

echo Processing ${BUILDPACK} buildpack

mkdir ${BUILD_FOLDER}
tar -xzf ${GITHUB_REPO}/source.tar.gz --strip-components=1 -C ${BUILD_FOLDER}

pushd ${BUILD_FOLDER} > /dev/null

bundle install
bundle exec rake clean package OFFLINE=true PINNED=true

popd > /dev/null

mv ${BUILD_FOLDER}/build/*.zip ${OUTPUT_FOLDER}

if [[ -f ${GITHUB_REPO}/body ]]; then
  echo Processing ${BUILDPACK} buildpack release notes
  cp ${GITHUB_REPO}/body ${OUTPUT_FOLDER}/${BUILDPACK}_buildpack-cached-$(cat ${GITHUB_REPO}/version)-release.md
fi

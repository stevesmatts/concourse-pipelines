#!/usr/bin/env bash

set -e

RELEASE_NAME=$1-$(cat incoming-release/version).tgz

mkdir -p /repo/$2
cp incoming-release/release.tgz /repo/$2/${RELEASE_NAME}
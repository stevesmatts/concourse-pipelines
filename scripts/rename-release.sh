#!/usr/bin/env bash

set -e

RELEASE_NAME=$1-$(cat incoming-release/version).tgz

cp incoming-release/release.tgz release/${RELEASE_NAME}
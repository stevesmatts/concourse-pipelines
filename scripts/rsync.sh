#!/usr/bin/env bash

set -e
set -o pipefail

SERVER=$1
USERNAME=$2
KEY_BASE64=$3
INCOMING_DIRECTORY=$4
OUTPUT_DIRECTORY=$5

mkdir -p ~/.ssh
echo -e ${KEY_BASE64} | base64 --decode > ~/.ssh/server_key
echo -e "Host ${SERVER}\n\tStrictHostKeyChecking no\n" > ~/.ssh/config
chmod -R 600 ~/.ssh

CMD="ssh -i ~/.ssh/server_key ${USERNAME}@${SERVER} mkdir -p ${OUTPUT_DIRECTORY}"
echo ${CMD} 1>&2
eval ${CMD} 1>&2

RSYNC_CMD="rsync -av -e 'ssh -i ~/.ssh/server_key' ./${INCOMING_DIRECTORY}/ ${USERNAME}@${SERVER}:${OUTPUT_DIRECTORY}"
echo ${RSYNC_CMD} 1>&2
eval ${RSYNC_CMD} 1>&2

#!/usr/bin/env bash

CREDENTIAL_FILE=credentials.yml
TARGET=mirror

PIPELINE_FILES=pipelines/*

for FILE in ${PIPELINE_FILES}
do
    PIPELINE_FILE=$(basename -- "$FILE")
    PIPELINE="${PIPELINE_FILE%.*}"
    fly -t ${TARGET} sp -n -p ${PIPELINE} -c pipelines/${PIPELINE_FILE} --load-vars-from credentials.yml
    fly -t mirror up -p ${PIPELINE}
done
#!/bin/bash

# Adapted from https://github.com/moikot/golang-dep/blob/8234ce5/.travis/push.sh#L127

set -euo pipefail


: ${DOCKER_REPO?Value required}
: ${DOCKER_USERNAME?Value required}
: ${DOCKER_PASSWORD?Value required}
: ${DOCKER_TOKEN:=}
: ${README_FILE:=README.md}


if [[ -z "${DOCKER_TOKEN}" ]]; then
    export DOCKER_TOKEN=$(curl -s -H "Content-Type: application/json" \
        -X POST \
        -d '{"username": "'${DOCKER_USERNAME}'", "password": "'${DOCKER_PASSWORD}'"}' \
        https://hub.docker.com/v2/users/login/ | jq -r .token)
fi


HTTP_CODE=$(jq -n --arg DESCRIPTION "$(<${README_FILE})" \
    '{"registry":"registry-1.docker.io","full_description": $DESCRIPTION }' | \
    curl -s -o /dev/null  -L -w "%{http_code}" \
    "https://cloud.docker.com/v2/repositories/${DOCKER_REPO}/" \
    -d @- -X PATCH \
    -H "Content-Type: application/json" \
    -H "Authorization: JWT ${DOCKER_TOKEN}")


if [[ "${HTTP_CODE}" = "200" ]]; then
    printf "Successfully pushed ${README_FILE} for ${DOCKER_REPO}\n"
else
    printf "Unable to push ${README_FILE} for ${DOCKER_REPO}, response code: %s\n" "${HTTP_CODE}"
    exit 1
fi


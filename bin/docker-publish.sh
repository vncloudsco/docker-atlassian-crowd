#!/bin/sh

REPO_NAME="$1"
IMAGE="$2"

for tag in $(git tag -l --points-at HEAD); do
    docker tag "$IMAGE" "${REPO_NAME}":"${tag}"
    docker push "$REPO_NAME":"$tag"
done
#!/bin/bash

set -eu
set -o pipefail

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
# Supported platforms: linux/arm64,linux/amd64,linux/arm/v7
PLATFORMS="$("${BIN_DIR}/list-platforms.sh" -t)"

if [[ -z ${CONTAINER_REGISTRY_USERNAME} ]] || [[ -z ${CONTAINER_REGISTRY_PASSWORD} ]]; then
  echo "CONTAINER_REGISTRY_USERNAME and CONTAINER_REGISTRY_PASSWORD must be set in order to push"
  exit 1
fi

echo "${CONTAINER_REGISTRY_PASSWORD}" | docker login -u "${CONTAINER_REGISTRY_USERNAME}" --password-stdin

tags="$("${BIN_DIR}/list-tags.sh")"
while read -r tag; do
  echo "Deploying ${tag} to dockerhub"
  docker buildx build \
    --platform "${PLATFORMS}" \
    --file Containerfile \
    --tag "${tag}" \
    --push \
    .
done <<< "${tags}"

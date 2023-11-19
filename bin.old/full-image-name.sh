#!/bin/bash

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
IMAGE_NAME="$("${BIN_DIR}/image-name.sh")"
CONTAINER_REGISTRY="docker.io/boxcutter"
FULL_IMAGE_NAME="${CONTAINER_REGISTRY}/${IMAGE_NAME}"

echo "${FULL_IMAGE_NAME}"

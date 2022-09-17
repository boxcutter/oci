#!/bin/bash

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"
CONTAINERFILE_DIR=$(pwd)
IMAGE_NAME="$(${BIN_DIR}/image-name.sh)"
CONTAINER_REGISTRY="docker.io/boxcutter"
FULL_IMAGE_NAME="${CONTAINER_REGISTRY}/${IMAGE_NAME}"

echo "${FULL_IMAGE_NAME}"

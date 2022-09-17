#!/bin/bash

set -eu
set -o pipefail

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"
CONTAINERFILE_DIR=$(pwd)
FULL_IMAGE_NAME="$(${BIN_DIR}/full-image-name.sh)"

docker image inspect "${FULL_IMAGE_NAME}" | jq -r '.[] | .Config.Labels."org.opencontainers.image.description"'

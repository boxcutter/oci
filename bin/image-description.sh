#!/bin/bash

set -eu
set -o pipefail

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
FULL_IMAGE_NAME="$("${BIN_DIR}/full-image-name.sh")"

docker image inspect "${FULL_IMAGE_NAME}" | jq -r '.[] | .Config.Labels."org.opencontainers.image.description"'

#!/bin/bash

set -eu
set -o pipefail

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
FULL_IMAGE_NAME="$("${BIN_DIR}"/full-image-name.sh)"

echo "==> Building ${FULL_IMAGE_NAME}"
docker buildx build \
  --load \
  --file Containerfile \
  --tag "${FULL_IMAGE_NAME}" \
  .

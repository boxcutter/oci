#!/bin/bash

set -eu
set -o pipefail

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
DEFAULT_TAG="$("${BIN_DIR}/list-tags.sh" | head -n 1)"

echo "==> Building ${DEFAULT_TAG}"
docker buildx build \
  --load \
  --file Containerfile \
  --tag "${DEFAULT_TAG}" \
  .

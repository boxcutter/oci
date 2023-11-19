#!/bin/bash

set -eu
set -o pipefail

HADOLINT_CONTAINER_IMAGE=docker.io/boxcutter/hadolint:2.12.0

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"

docker container run --rm -i \
  "${HADOLINT_CONTAINER_IMAGE}" hadolint - < "Containerfile"

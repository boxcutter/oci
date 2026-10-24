#!/bin/bash

set -eu
set -o pipefail

HADOLINT_CONTAINER_IMAGE=docker.io/boxcutter/hadolint:2.15.1

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"

docker container run --rm -i \
  "${HADOLINT_CONTAINER_IMAGE}" hadolint --failure-threshold error - < "Containerfile"

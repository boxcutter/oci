#!/bin/bash

set -eu
set -o pipefail

HADOLINT_CONTAINER_IMAGE=boxcutter/hadolint:2.10.0

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"
CONTAINERFILE_DIR=$(pwd)

"${BIN_DIR}/check-image.sh" "${HADOLINT_CONTAINER_IMAGE}"

if [[ -f "${BIN_DIR}/hadolint-ignore" ]]; then
  lints_to_ignore=$(sed "s/#.*//" "${BIN_DIR}/hadolint-ignore" | sed '/^[[:space:]]*$/d' | sed 's/^/--ignore / ' | tr '\n' ' ')
  docker container run --rm -i ${HADOLINT_CONTAINER_IMAGE} hadolint ${lints_to_ignore} - < "Containerfile"
  exit 0
fi

docker container run --rm -i ${HADOLINT_CONTAINER_IMAGE} hadolint - < "Containerfile"

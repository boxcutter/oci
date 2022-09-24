#!/bin/bash

set -eu
set -o pipefail

HADOLINT_CONTAINER_IMAGE=boxcutter/hadolint:2.10.0

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"

"${BIN_DIR}/check-image.sh" "${HADOLINT_CONTAINER_IMAGE}"

# shellcheck disable=SC2086
if [[ -f "${BIN_DIR}/hadolint-ignore" ]]; then
  lints_to_ignore=$(sed "s/#.*//" "${BIN_DIR}/hadolint-ignore" | sed '/^[[:space:]]*$/d' | sed 's/^/--ignore / ' | tr '\n' ' ')
  docker container run --rm -i "${HADOLINT_CONTAINER_IMAGE}" hadolint ${lints_to_ignore} - < "Containerfile"
  exit 0
fi

docker container run --rm -i "${HADOLINT_CONTAINER_IMAGE}" hadolint - < "Containerfile"

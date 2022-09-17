#!/bin/bash

set -eu
set -o pipefail

DASEL_CONTAINER_IMAGE=boxcutter/dasel:1.26.1

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"
CONTAINERFILE_DIR=$(pwd)

MODE=plain
DEFAULT_TAG="$(${BIN_DIR}/full-image-name.sh)"

usage() {
  cat <<EOF
Usage:  $0

  -d    Enable debug messages
  -h    Print help
  -c    Print tags in CSV format for GitHub Actions
  -t    Print tags in plain text (default)
EOF
}

args() {
  while getopts dhct opt; do
    case "$opt" in
      d)
        DEBUG=1
        ;;
      h)
        usage
        exit
        ;;
      c)
        MODE=csv
        ;;
      t)
        MODE=plain
        ;;
    esac
  done
}

print_tags_stdout() {
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq -r '.container_image.tags | \"${DEFAULT_TAG}:\" + .[]'"
}

print_tags_csv() {
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq -r '[ .container_image.tags | \"${DEFAULT_TAG}:\" + .[] ] | @csv'"
}

args $*
DEFAULT_TAG="$(${BIN_DIR}/full-image-name.sh)"

if [[ -f "${CONTAINERFILE_DIR}/Polly.toml" ]]; then
  if [[ "$MODE" == "csv" ]]; then
    print_tags_csv
  else
    print_tags_stdout
  fi
else
  echo "${DEFAULT_TAG}"
fi

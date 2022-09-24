#!/bin/bash

set -eu
set -o pipefail

DASEL_CONTAINER_IMAGE=boxcutter/dasel:1.26.1

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
CONTAINERFILE_DIR=$(pwd)

MODE=plain
DEFAULT_TAG="$("${BIN_DIR}/full-image-name.sh")"

usage() {
  cat <<EOF
Usage:  $0

  -h    Print help
  -c    Print tags in CSV format for GitHub Actions
  -t    Print tags in plain text (default)
EOF
}

args() {
  while getopts hct opt; do
    case "$opt" in
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
      *)
        usage
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

check_for_tags_field() {
  result=$(docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq -r '.container_image.tags'")
  if [[ $result == "null" ]]; then
    echo "${DEFAULT_TAG}"
    exit
  fi
}

args "$@"
DEFAULT_TAG="$("${BIN_DIR}/full-image-name.sh")"

if [[ -f "${CONTAINERFILE_DIR}/Polly.toml" ]]; then
  check_for_tags_field
  if [[ "$MODE" == "csv" ]]; then
    print_tags_csv
  else
    print_tags_stdout
  fi
else
  echo "${DEFAULT_TAG}"
fi

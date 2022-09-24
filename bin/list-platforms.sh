#!/bin/bash

set -eu
set -o pipefail

DASEL_CONTAINER_IMAGE=boxcutter/dasel:1.26.1

CONTAINERFILE_DIR=$(pwd)

MODE=plain
DEFAULT_PLATFORMS=linux/arm64,linux/amd64,linux/arm/v7

usage() {
  cat <<EOF
Usage:  $0

  -h    Print help
  -c    Print tags in CSV format for GitHub Actions
  -t    Print tags in plain test format (default)
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

print_platforms_plain() {
  # Check to see if the key exists and return default if error
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq --exit-status --raw-output '.container_image.platforms'" &>/dev/null || { echo "${DEFAULT_PLATFORMS}"; exit 0; }

  # Now we know the key exists, return the value
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq --raw-output '.container_image.platforms | join(\",\")'"
}

print_platforms_csv() {
  # Check to see if the key exists and return default if error
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq --exit-status --raw-output '.container_image.platforms'" &>/dev/null || { echo "${DEFAULT_PLATFORMS}"; exit 0; }

  # Now we know the key exists, return the value
  docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    --entrypoint /bin/bash \
    ${DASEL_CONTAINER_IMAGE} \
      -c "dasel -f Polly.toml -w json | jq --raw-output '.container_image.platforms | @csv'"
}

args "$@"

if [[ -f "${CONTAINERFILE_DIR}/Polly.toml" ]]; then
  if [[ "$MODE" == "csv" ]]; then
    print_platforms_csv
  else
    print_platforms_plain
  fi
else
  if [[ "$MODE" == "csv" ]]; then
    cat <<EOF
"linux/arm64","linux/amd64","linux/arm/v7"
EOF
  else
    cat <<EOF
linux/arm64,linux/amd64,linux/arm/v7
EOF
  fi
fi

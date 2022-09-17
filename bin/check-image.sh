#!/bin/bash

set -eu
set -o pipefail

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"

usage() {
  echo "Usage:  $0 IMAGE"
  echo
  echo "Verify that an image exists"
}

check_docker() {
  # Check if Docker is running
  if ! docker info >/dev/null 2>&1; then
    echo "Docker does not appear to be running, start the daemon first and retry."
    exit 1
  fi
}

check_if_image_local() {
  local image_name="$1"

  if docker image inspect "${image_name}" >/dev/null 2>&1; then
    exit 0
  fi
}

not_found() {
  local image_name="$1"

cat <<EOF

${image_name} does not appear to be available.

If you need to bootstrap the image, go to the Containerfile directory and run:

  ${BIN_DIR}/build-push.sh 
EOF
  exit 1
}

while getopts h opt; do
  case "$opt" in
    h)
      usage
      exit
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

if [ $# -lt 1 ]; then
  usage
  exit 1
fi

check_docker
check_if_image_local "$1"
echo "==> $1 not found, attempting to pull image from dockerhub"
if ! docker image pull "$1" >/dev/null 2>&1; then
  not_found "$1"
fi

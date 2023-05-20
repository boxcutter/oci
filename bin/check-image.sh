#!/bin/bash

set -eu
set -o pipefail

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

not_found() {
  local image_name="$1"

cat <<EOF

${image_name} does not appear to be available.

If you need to bootstrap the image, go to the Containerfile directory and run:

  docker buildx build \
    --platform linux/amd64,linux/arm64/v8,linux/arm/v7 \
    --file Containerfile \
    --tag ${image_name} \
    --push \
    .
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
if ! docker image pull "$1" >/dev/null 2>&1; then
  not_found "$1"
fi

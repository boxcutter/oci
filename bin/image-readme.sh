#!/bin/bash

set -eu

DASEL_CONTAINER_IMAGE=boxcutter/dasel:1.26.1

BIN_DIR="$(dirname -- "$(readlink -f "${BASH_SOURCE[0]}")")"
CONTAINERFILE_DIR=$(pwd)
README_FILEPATH=${PWD##*/}/README.md

if [[ -f "${CONTAINERFILE_DIR}/Polly.toml" ]]; then
  _name=$(docker container run --rm \
    --mount type=bind,source="$(pwd)",target=/share,readonly \
    ${DASEL_CONTAINER_IMAGE} \
      -f Polly.toml --null "container_image.readme")

  if [ "${_name}" != "null" ]; then
    README_FILEPATH=${_name}
  fi
fi
# Without a config file, the image name is assumed to be the directory name
echo "${README_FILEPATH}"

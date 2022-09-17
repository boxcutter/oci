#!/bin/bash

set -eu
set -o pipefail

CINC_AUDITOR_CONTAINER_IMAGE=boxcutter/cinc-auditor:5.18.14

SCRIPT_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
BIN_DIR="${SCRIPT_PATH}"
CONTAINERFILE_DIR=$(pwd)
CINC_PROFILE_DIR="${CONTAINERFILE_DIR}/test"

usage() {
  cat <<EOF
Usage:  $0 [IMAGE_NAME] [ENTRYPOINT_COMMAND]

Test image with cinc-auditor

  -h    Print help
EOF
}

args() {
  while getopts h opt; do
    case "$opt" in
      h)
        usage
        exit
        ;;
    esac
  done

  if [ "$*" == "" ]; then
    TEST_CONTAINER_IMAGE="$(${BIN_DIR}/full-image-name.sh)"
  else
    TEST_CONTAINER_IMAGE=$1
  fi

  ENTRYPOINT_COMMAND="/bin/bash"
  if [ "$#" -gt 1 ]; then
    ENTRYPOINT_COMMAND="$2"
  fi
}

start_image_under_test() {
  CONTAINER_ID=$(docker container run --interactive --entrypoint "${ENTRYPOINT_COMMAND}" --detach $TEST_CONTAINER_IMAGE )
}

run_cinc_auditor() {
  echo "==> running cinc-auditor against ${TEST_CONTAINER_IMAGE}"
  echo "==> with command: '${ENTRYPOINT_COMMAND}'"
  docker container run -t --rm \
    -v "${CINC_PROFILE_DIR}:/share" \
    -v /var/run/docker.sock:/var/run/docker.sock \
    ${CINC_AUDITOR_CONTAINER_IMAGE} exec . --no-create-lockfile -t docker://${CONTAINER_ID}
}

cleanup_image_under_test() {
  set +u
  if [ ! -z "$CONTAINER_ID" ]; then
    echo "==> stopping ${CONTAINER_ID}"
    docker container stop ${CONTAINER_ID}
    echo "==> removing ${CONTAINER_ID}"
    docker container rm ${CONTAINER_ID}
  fi
  set -u
}

trap cleanup_image_under_test EXIT

"${BIN_DIR}/check-image.sh" "${CINC_AUDITOR_CONTAINER_IMAGE}"
args $*
start_image_under_test
run_cinc_auditor


#!/bin/bash

# set -x
set -eu
set -o pipefail

CINC_AUDITOR_CONTAINER_IMAGE=docker.io/boxcutter/cinc-auditor:6.8.11

CONTAINERFILE_DIR=$(pwd)
CINC_PROFILE_DIR="${CONTAINERFILE_DIR}/test"

# Assume we're building one image in this case. Even if we have multiple
# tags, there shouldn't be any difference between them. So just grab the
# first tag in the list, as it is as good as any other.
json_data="$(docker buildx bake local --print 2>/dev/null)"
DEFAULT_TAG=$(echo "$json_data" | jq -r '.target[] | .tags[0]' | head -n 1)

usage() {
  cat <<EOF
Usage:  $0 [IMAGE_NAME] [ENTRYPOINT_COMMAND]

Test image with cinc-auditor

  -h    Print help
  -e    Return error if profile does not exist
EOF
}

args() {
  ERROR_IF_PROFILE_DOES_NOT_EXIST=0
  while getopts he opt; do
    case "$opt" in
      h)
        usage
        exit
        ;;
      e)
        ERROR_IF_PROFILE_DOES_NOT_EXIST=1
        ;;
      *)
        usage
        ;;
    esac
  done

  if [ "$*" == "" ]; then
    TEST_CONTAINER_IMAGE="${DEFAULT_TAG}"
  else
    TEST_CONTAINER_IMAGE=$1
  fi

  ENTRYPOINT_COMMAND="/bin/bash"
  if [ "$#" -gt 1 ]; then
    ENTRYPOINT_COMMAND="$2"
  fi
}

check_profile() {
  if [ ! -d "${CINC_PROFILE_DIR}" ]; then
    echo "==> ${CINC_PROFILE_DIR} does not exist."
    exit ${ERROR_IF_PROFILE_DOES_NOT_EXIST}
  fi
}

start_image_under_test() {
  CONTAINER_ID=$(docker container run --interactive --entrypoint "${ENTRYPOINT_COMMAND}" --detach "$TEST_CONTAINER_IMAGE" )
}

run_cinc_auditor() {
  echo "==> running cinc-auditor against ${TEST_CONTAINER_IMAGE}"
  echo "==> with command: '${ENTRYPOINT_COMMAND}'"
  docker container run -t --rm \
    --mount type=bind,source="${CINC_PROFILE_DIR}",target=/share \
    --mount type=bind,source=/var/run/docker.sock,target=/var/run/docker.sock \
    "${CINC_AUDITOR_CONTAINER_IMAGE}" exec .  --no-distinct-exit --no-create-lockfile --input test_container_image="${TEST_CONTAINER_IMAGE}" -t "docker://${CONTAINER_ID}"
}

cleanup_image_under_test() {
  set +u
  if [ -n "$CONTAINER_ID" ]; then
    echo "==> stopping ${CONTAINER_ID}"
    docker container stop "${CONTAINER_ID}"
    echo "==> removing ${CONTAINER_ID}"
    docker container rm "${CONTAINER_ID}"
  fi
  set -u
}

trap cleanup_image_under_test EXIT

args "$@"
check_profile
start_image_under_test
run_cinc_auditor

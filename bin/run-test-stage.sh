#!/bin/bash

set -eu -o pipefail

json_data="$(docker buildx bake --print 2>/dev/null)"
first_build_target=$(echo "$json_data" | jq -r '.target | to_entries[0].value')
if echo "$first_build_target" | jq -e '.labels."dev.polymathrobotics.test.container-build-publish-action.run-test-stage"' > /dev/null; then
  run_test_stage=$(echo "$first_build_target" | jq -r '.labels."dev.polymathrobotics.test.container-build-publish-action.run-test-stage"')
  echo "$run_test_stage"
else
  echo "true"
fi

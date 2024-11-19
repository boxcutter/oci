#!/bin/bash

set -eu -o pipefail

json_data="$(docker buildx bake --print 2>/dev/null)"
first_build_target=$(echo "$json_data" | jq -r '.target | to_entries[0].value')
if echo "$first_build_target" | jq -e '.labels."dev.boxcutter.container-build-publish-action.test-entrypoint"' > /dev/null; then
  test_entrypoint=$(echo "$first_build_target" | jq -r '.labels."dev.boxcutter.container-build-publish-action.test-entrypoint"')
  echo "$test_entrypoint"
else
  echo "/bin/bash"
fi

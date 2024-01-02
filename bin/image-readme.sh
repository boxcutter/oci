#!/bin/bash

set -eu -o pipefail

json_data="$(docker buildx bake --print 2>/dev/null)"
first_build_target=$(echo "$json_data" | jq -r '.target | to_entries[0].value')
if echo "$first_build_target" | jq -e '.labels."dev.boxcutter.image.readme-filepath"' > /dev/null; then
  readme_filepath=$(echo "$first_build_target" | jq -r '.labels."dev.boxcutter.image.readme-filepath"')
  echo "$readme_filepath"
else
  echo "./README.md"
fi

#!/bin/bash

set -eu -o pipefail

json_data="$(docker buildx bake --print 2>/dev/null)"
first_build_target=$(echo "$json_data" | jq -r '.target | to_entries[0].value')
image_title=$(echo "$first_build_target" | jq -r '.labels."org.opencontainers.image.title"')
# if there is a namespace, remove it
image_name="${image_title##*/}"
echo "$image_name"

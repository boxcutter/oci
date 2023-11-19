#!/bin/bash

docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/code,readonly \
  docker.io/boxcutter/bats test/

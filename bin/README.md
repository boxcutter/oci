# bin

This directory contains supporting scripts for the build system. Using shell
scripts makes it easy for the devs to build images locally without needing
any other tooling installed.

There are top level scripts used in each stage of our build pipeline:
- lint
  - `lint.sh` - Runs hadolint to lint Containerfiles
  - `hadolint-ignore` - Global list of hadolint error codes to ignore
- test
  - `build-local.sh` - Generates one container image matching the local
    platform architecture on which to run tests
- build
  - `build-push.sh` - Build a multi-architecture container image and
    push the result to a container registry

These are supporting scripts used to read build parameters out of Polly.toml
files:
- `full-image-name.sh` - prints full image name using config info from Polly.toml (e.g. docker.io/polymathrobotics/ros:noetic)
- `image-name.sh` - prints image name component of full image name using config info from Polly.toml (e.g. ros)
- `list-platforms.sh` - prints image platforms from Polly.toml
- `list-tsgs.sh` - prints tag component of full image name using config info from Polly.toml (e.g. noetic)

These are the rest of the supporting scripts:
- `check-image.sh` - checks if an image is present in a container registry
- `image-description.sh` - prints image description using container image label metadata

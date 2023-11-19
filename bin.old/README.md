# bin [![oci](https://github.com/boxcutter/oci/actions/workflows/bin.yml/badge.svg)](https://github.com/boxcutter/oci/actions/workflows/bin.yml)

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
  - `test.sh` - Run cinc-auditor tests    
- build
  - `build-push.sh` - Build a multi-architecture container image and
    push the result to a container registry

These are supporting scripts used to read build parameters out of Polly.toml
files:
- `full-image-name.sh` - prints full image name using config info from Polly.toml (e.g. docker.io/polymathrobotics/ros:noetic)
- `image-name.sh` - prints image name component of full image name using config info from Polly.toml (e.g. ros)
- `image-readme.sh` - prints readme path used for syncing with DockerHub
- `list-platforms.sh` - prints image platforms from Polly.toml
- `list-tags.sh` - prints tag component of full image name using config info from Polly.toml (e.g. noetic)

These are the rest of the supporting scripts:
- `check-image.sh` - checks if an image is present in a container registry
- `image-description.sh` - prints image description using container image label metadata
- `run_shellcheck.sh` - runs shellcheck linter on the bash scripts in this directory
- `run_tests.sh` - runs bats tests on the bash scripts in this directory

We use bats to verify the scripts. Because the scripts use container images,
it's easier to have the bats scripts running on the host outside of docker.
So we add the bats scripts via submodules. They were created with the following
commands:

```
mkdir -p test/test_helper
git submodule add https://github.com/bats-core/bats-core.git test/bats
git submodule add https://github.com/bats-core/bats-support.git test/test_helper/bats-support
git submodule add https://github.com/bats-core/bats-assert.git test/test_helper/bats-assert
```

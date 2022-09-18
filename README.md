# oci
Supporting open container images

# Navigating

The repo has the following structure:

- `bin/` contains supporting scripts used to create container images. This
  allows maintainers to more easily run parts of the build locally for
  troubleshooting. The build system shells out to the same scripts so
  everything uses the same code, whether or not you are building locally or
  using automated builds in the cloud.

- `src/` contains all the source code for the images, primarily
  Containerfiles/Dockerfiles in BuildKit format.

# Alphabetical index of images

| Image | Description | Location | DockerHub URL |
| --- | --- | --- | --- |
| cinc-auditor | Framework for testing infrastructure compatible with Chef InSpec | [src/bootstrap/cinc-auditor](https://github.com/boxcutter/oci/tree/main/src/bootstrap/cinc-auditor) | https://hub.docker.com/r/boxcutter/cinc-auditor |
| dasel | Command line process for JSON, YAML, TOML, XML and CSV files | [src/bootstrap/dasel](https://github.com/boxcutter/oci/tree/main/src/bootstrap/dasel) | https://hub.docker.com/r/boxcutter/dasel |
| hadolint | Containerfile/Dockerfiles linter | [src/bootstrap/hadolint](https://github.com/boxcutter/oci/tree/main/src/bootstrap/hadolint) | https://hub.docker.com/r/boxcutter/dasel |

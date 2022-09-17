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

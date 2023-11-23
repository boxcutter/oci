# oci - Open Container Initiative (OCI) images [![oci](https://github.com/boxcutter/oci/actions/workflows/ci.yml/badge.svg)](https://github.com/boxcutter/oci/actions/workflows/ci.yml)
Open container images for robotics, neuromorphic engineering, systems and embedded applications.

# Alphabetical index of images

| Image | Description | Location
| --- | --- | --- |
| [aws-cli](https://hub.docker.com/r/boxcutter/aws-cli) | Amazon Web Services Command-Line Interface | [aws-cli](https://github.com/boxcutter/oci/tree/main/aws-cli) |
| [black](https://hub.docker.com/r/boxcutter/black) | Black is the uncompromising Python code formatter | [black](https://github.com/boxcutter/oci/tree/main/black) |
| [cinc-auditor](https://hub.docker.com/r/boxcutter/cinc-auditor) | Framework compatible with Chef InSpec for testing infrastructure | [cinc/cinc-auditor](https://github.com/boxcutter/oci/tree/main/cinc/cinc-auditor) |
| [fpm](https://hub.docker.com/r/boxcutter/fpm) | fpm Packaging made simple | [fpm](https://github.com/boxcutter/oci/tree/main/fpm) |
| [hadolint](https://hub.docker.com/r/boxcutter/hadolint) | Containerfile/Dockerfiles linter | [hadolint](https://github.com/boxcutter/oci/tree/main/hadolint) |
| [meshcmd](https://hub.docker.com/r/boxcutter/meshcmd) | Command line tool used to perform many tasks related to computer management of Intel Active Management Technology (AMT) devices | [meshcmd](https://github.com/boxcutter/oci/tree/main/meshcmd) |

# Why are you re-publishing some official images?

Re-packaging is a time-honored trend in system administration! It's not as common as you might think to use a vanilla install
to manage a fleet of servers. Software installs often need to be re-packaged and re-mixed for a specific purpose. In our
case for robotics, neuromorphic engineering, systems and embedded applications.

It's not as consistent as one would hope to allow a rootless deploy of some official images. In some cases we need to re-mix
a container image for that reason.

For embedded and systems work, we need images built for a variety of processors, not all official images provide builds even
for intel, arm64 and arm32 chips. So we try as much as we can for a wider variety of platforms.

Very few official images use Ubuntu as a base image in their "FROM" field. The container images produced from this repository
nearly all consistently use Ubuntu as the base image, which is the preferred base for a lot of robotics applications.

Also because a lot of AI applications use Python heavily, it's not a good idea to use an alpine base image. It does not have
a compatible C-runtime. And adding all the necessary C dependencies to an alpine image ironically makes it BIGGER than an
equivalent Debian/Ubuntu image.

The official Debian images aren't nearly as good as a base for container images as the Ubuntu ones, because they are updated
less frequently with security updates than the Ubuntu ones. Most Debian base images contain more security vulnerabilities
than the equivalent Ubuntu ones, simply because they aren't updated as often. Also the commonly used "buildpack-deps" base
images contain a lot of extra unused packages that aren't ever used in ROS, like the subversion, bzr and mercurial source
control management programs to try to save space for a broader set of images. This unfortunately also increases the threat
surface with a lot of extra packages we don't need, so we prefer not to use "buildpack-deps" where feasible.

It would be best to use Google's distroless images, but they are on the other end of the spectrum for dependencies, they
don't include nearly enough. The Ubuntu images strike the best compromise in having most of the packages we need for our
applications while not having too much that we don't need.

# Navigating

The repo has the following structure:

- `bin/` contains supporting scripts used to create container images. This
  allows maintainers to more easily run parts of the build locally for
  troubleshooting. The build system shells out to the same scripts so
  everything uses the same code, whether or not you are building locally or
  using automated builds in the cloud.

- Rest of the directories contain all the source code for the images, primarily Containerfiles/Dockerfiles in BuildKit format. An alphabetical index is also provided in this README.md.
  
# Developing

Following container image conventions there is a separate directory for each container image. The container image
tools have a single target directory for source files and by default the image tools scan all files in a directory
for some operations. Thus there is a subdirectory per image, though a single image may be built for multiple
platforms. GitHub Actions pipelines in `.github/workflows` have been set up to publish these images to the
[boxcutter org](https://hub.docker.com/u/boxcutter) on DockerHub.

Since container image source code packaging is small, for convenience all the source is together in one big
repo. There alphabetical index for all the images below.

When a new image is added, the base directory is added to the list of directories in `.github/workflows/ci.yml`.
There's a rule that fires a build for each image only when a particular directory contents are changed.

Each source directory has a similar basic structure. The image directory is not required to be at any particular
level in the directory hieararchy. Some of images have are grouped vendor or application type.

```
├── <image name>
│   ├── .dockerignore
│   ├── Containerfile
│   ├── docker-bake.hcl
│   ├── README.md
│   ├── test
│   │   ├── controls
│   │   │   ├── <inspec *.rb files>
```

The files are as follows:
- `.dockerignore` - standard .dockerignore, list of files that should be ignored during a build to increase
  performance.
- `Containerfile` - a file using the Dockerfile DSL that includes commands for building an image. We process
  Containerfiles with BuildKit and encourge image authors to make use of BuildKit-specific features in
  image builds.
- `docker-bake.hcl` - A Docker Bake file that builds the image with `docker buildx bake`.
- `test/` - subdirectory containing an InSpec profile with tests for the contaimer image.

## Building these container images locally

Normally we just use the GitHub Actions pipelines that have been configured in `.github/workflows` to build
these images. However, the scripts to build the container images in the `/bin` subdirectory can be used to
build any image locally on your machine. For example, to build `ros-core`:

```bash
# Make the current working directory the location of the Containerfile for the image you want to build
cd ros/ros-core
# Check the Containerfile with hadolint
$(git rev-parse --show-toplevel)/bin/lint.sh
# Build the image for testing on the local processor architecture
docker buildx create --use
docker buildx bake local --local
# Run tests on the image with cinc-auditor
$(git rev-parse --show-toplevel)/bin/test.sh
# (Optional) build and push the image to the container repository on dockerhub - ideally this should be done via a GitHub Actions workflow and not locally
docker build bake default
```

# l4t-base

Linux for Tegra (L4T) base image. Tegra is a system on a chip (SoC) series
developed by NVIDIA.

Based on:
- https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-base
- https://gitlab.com/nvidia/container-images/l4t-base

## What is L4T?

NVIDIA Linux4Tegra (L4T) package provides the bootloader, kernel, necessary
firmwares, NVIDIA drivers for various accelerators present on Jetson modules,
flashing utilities and a sample filesystem to be used on Jetson systems. The
software packages contained in L4T provide the functionality necessary to run
Linux on Jetson modules. For a detailed software overview please refer
documentation provided here: (https://docs.nvidia.com/jetson/l4t/index.html)

## Overview of the l4t-base container

l4t-base docker image enables applications to be run in a container using the
Nvidia Container Runtime on Jetson. It has a subset of packages from the l4t
rootfs included within (Multimedia, Gstreamer, Camera, Core, 3D Core, Vulkan,
Weston). The platform specific libraries providing hardware dependencies and
select device nodes for a particular device are mounted by the NVIDIA container
runtime into the l4t-base container from the underlying host, thereby providing
necessary dependencies for l4t applications to execute within the container.
This approach enables the l4t-base container to be shared between various
Jetson devices.

The image is tagged with the version corresponding to the release version of
the associated l4t release. Based on this, the l4t-base:r34.1 container is
intended to be run on devices executing the l4t r34.1 release.

Starting with the r32.4.3 release, the Dockerfile for the l4t-base docker image
is also being provided. This can be accessed at this [link](https://gitlab.com/nvidia/container-images/l4t-base). Users can use this to modify the contents to
suit their needs.

**Starting with the r34.1 release (JetPack 5.0 Developer Preview), the l4t-base
will not bring CUDA, CuDNN and TensorRT from the host file system.** The
l4t-base is meant to be used as the base container for containerizing
applications for Jetson. Users can apt install Jetson packages and other
software of their choice to extend the l4t-base dockerfile (see above) while
building application containers. All JetPack components are hosted in the
Debian Package Management server [here](https://repo.download.nvidia.com/jetson/).

For CUDA and TensorRT applications, users can use the L4T CUDA and TensorRT
runtime containers which have CUDA and CUDA/CuDNN/TensorRT respectively in the
container itself. They can be used as base containers to containerize [CUDA](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-cuda)
and [TensorRT](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorrt) applications on Jetson.

## Running l4t-base container

### Prerequisites

Ensure these prerequisites are available on your system:

1. [NVIDIA Container Runtime on Jetson](https://github.com/nvidia/nvidia-docker/wiki#platform-support) Note that NVIDIA Container Runtime is available for install as part of [Nvidia JetPack](https://developer.nvidia.com/embedded/jetpack) in version 4.3 or newer

### Pull the container

Before running the l4t-base container, use Docker pull to ensure an up-to-date image is installed. Once the pull is complete, you can run the container image.

Procedure

1. In the Pull column, click the icon to copy the Docker pull command for the l4t-base container.

1. Open a command prompt and paste the pull command. Docker will initiate a pull of the container from the NGC registry. Ensure the pull completes successfully before proceeding to the next step.

### Run the container

To run the container:

1. Allow external applications to connect to the host's X display:

       xhost *

1. Run the docker container using the docker command

       sudo docker run -it --rm \
           --net=host \
           --runtime nvidia \
           --env DISPLAY=$DISPLAY \
           --mount type=bind,source=/tmp/.X11-unix/,target=/tmp/.X11-unix \
           docker.io/polymathrobotics/nvidia-l4t-base:r35.4.1

### Exposing additional GPU features

By default a limited set of device nodes and associated functionality is
exposed within the l4t-base containers using the [mount plugin](https://github.com/NVIDIA/nvidia-docker/wiki/NVIDIA-Container-Runtime-on-Jetson#mount-plugins)
capability. The list is documented [here](https://github.com/NVIDIA/nvidia-docker/wiki/NVIDIA-Container-Runtime-on-Jetson#supported-devices).

User can expose additional devices using the [--device](https://docs.docker.com/engine/reference/commandline/run/#add-host-device-to-container---device)
command option provided by docker. Directories and files can be bind mounted
using the [-v](https://docs.docker.com/storage/bind-mounts/) option.

Note that usage of some devices might need associated libraries to be available inside the container.

### Creating Containers for Jetson

The following L4T containers can be readily leveraged as base containers to
create application containers: [CUDA](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-cuda), [TensorRT](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorrt), [Deepstream](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/deepstream-l4t), [TensorFlow](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-tensorflow), [PyTorch](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-pytorch), [ML](https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-ml).
The [NVIDIA Container RUntime on Jetson](https://github.com/nvidia/nvidia-docker/wiki#platform-support) documentation has a FAQ on container usage.

Refer to [this](https://gitlab.com/nvidia/container-images/l4t-jetpack)
git repo for sample dockerfile. The JetPack dockerfile in that repo uses L4T
container as base and creates a development container by installing CUDA,
cuDNN, TensorRT, VPI and OpenCV inside the container.

### License

The l4t-base container includes various software packages with their respective licenses included within the container.

### Suggested Reading

For more information about l4t refer [Jetson Download Center](https://developer.nvidia.com/embedded/downloads).

If you have questions, please refer to the [Jetson Forums](https://devtalk.nvidia.com/default/board/139/embedded-systems/1).

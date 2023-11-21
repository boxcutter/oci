# l4t-jetpack

## NVIDIA Jetpack

NVIDIA JetPack SDK is the most comprehensive solution for building end-to-end
accelerated AI applications. JetPack SDK provides a full development
environment for hardware-accelerated AI-at-the-edge development. It includes
complete set of libraries for acceleration of GPU computing, multimedia,
graphics, and computer vision.

Based on:
- https://catalog.ngc.nvidia.com/orgs/nvidia/containers/l4t-jetpack
- https://gitlab.com/nvidia/container-images/l4t-jetpack

## Overview of Image

NVIDIA L4T JetPack container containerizes all accelrated libraries that are
included in JetPack SDK, which includes CUDA, cuDNN, TensorRT, VPI, Jetson
Multimedia, and so on. This container can be used a development container for
containerized development as it includes all JetPack SDK components. The docker
file for this container can be found at this link. You can refer to the
dockerfile and use that recipe as a reference to create your own development
container (with both dev and runtime components) or deployment container (with
only runtime components)

## Running the container

## Prerequisites

Ensure that [NVIDIA Container Runtime on Jetson](https://github.com/nvidia/nvidia-docker/wiki#platform-support) is running on Jetson.

You can run this container on top of JetPack SDK installation. Note that NVIDIA
Container Runtime is available for install as part of [Nvidia JetPack](https://developer.nvidia.com/embedded/jetpack).

You can also run this container on top of Jetson Linux BSP after installing NVIDIA Container Runtime using

```
sudo apt install nvidia-container
```

## Pull the container

Before running the l4t-jetpack container, use Docker pull to ensure an up-to-date image is installed. Once the pull is complete, you can run the container image.

Procedure:

1. In the Pull column, click the icon to copy the Docker pull command for the l4t-jetpack container.
1. Open a command prompt and paste the pull command. Docker will initiate a pull of the container from the NGC registry. Ensure the pull completes successfully before proceeding to the next step.

## Run the container

To run the container:

1. Allow external applications to connect to the host's X display:

    xhost +

1. Run the docker container using the docker command:

    sudo docker run -it --rm \
        --net=host \
        --runtime nvidia \
        -e DISPLAY=$DISPLAY \
        -v /tmp/.X11-unix/:/tmp/.X11-unix \
        nvcr.io/nvidia/l4t-jetpack:r35.3.1

Options explained:

-it means run in interactive mode
--rm will delete the container when finished
--runtime nvidia will use the NVIDIA container runtime while running the l4t-base container
-v is the mounting directory, and used to mount host's X11 display in the container filesystem to render output videos
r35.3.1 is the tag for the jetpack image corresponding to the l4t release

## Exposing addition features

By default a limited set of device nodes and associated functionality is
exposed within the cuda-runtime containers using the mount plugin capability.
This list is documented [here](https://github.com/NVIDIA/nvidia-docker/wiki/NVIDIA-Container-Runtime-on-Jetson#supported-devices).

User can expose additional devices using the [--device](https://docs.docker.com/engine/reference/commandline/run/#add-host-device-to-container---device) command option provided by docker. Directories and files can be bind mounted using the [-v](https://docs.docker.com/storage/bind-mounts/) option.

Note that usage of some devices might need associated libraries to be available inside the container.

## Run a sample application

Once you have successfully launched the l4t-jetpack container, you can run some tests inside it.

1. To run the CUDA sample test, run the following commands within the container:

    apt-get update && apt-get install -y --no-install-recommends make g++
    cp -r /usr/local/cuda/samples /tmp
    cd /tmp/samples/1_Utilities/deviceQuery
    make
    ./deviceQuery

Output should indicate that the sample passed.

1. To run the cuDNN sample test, run the following commands within the container:

    cp -r /usr/src/cudnn_samples_v8/ /tmp/
    cd /tmp/cudnn_samples_v8/conv_sample/
    make
    ./conv_sample

Output should indicate that the sample passed.

3. To run the TensorRT sample test, run the following commands within the container:

    /usr/src/tensorrt/bin/trtexec --model=/usr/src/tensorrt/data/googlenet/googlenet.caffemodel --deploy=/usr/src/tensorrt/data/googlenet/googlenet.prototxt --output=prob
    /usr/src/tensorrt/bin/trtexec --model=/usr/src/tensorrt/data/googlenet/googlenet.caffemodel --deploy=/usr/src/tensorrt/data/googlenet/googlenet.prototxt --output=prob --useDLACore=0 --allowGPUFallback

Outputs should indicate that the samples passed.

Note: DLA is not supported on Orin Nano

1. To run the VPI sample test, run the following commands within the container:

    apt install cmake
    cp -r /opt/nvidia/vpi*/samples /tmp
    cd /tmp/samples/01-convolve_2d/
    mkdir build
    cd build
    cmake ..
    make -j4
    ./vpi_sample_01_convolve_2d cuda /opt/nvidia/vpi2/samples/assets/kodim08.png
    ./vpi_sample_01_convolve_2d cpu /opt/nvidia/vpi2/samples/assets/kodim08.png

Note: VPI currently does not support PVA backend within containers.

## End User License Agreement

By pulling and using the container, you accept the terms and conditions of this [End User License Agreement](https://docs.nvidia.com/jetson/jetpack/eula/index.html).

## Documentation

For more information on JetPack, including the release notes, programming model, APIs and developer tools, visit the [JetPack documentation site](https://developer.nvidia.com/embedded/jetpack).

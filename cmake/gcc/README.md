# cmake-gcc

CMake build system with the GCC compiler toolchain (`gcc`, `g++` and `make`, from Ubuntu's `build-essential`) and Ninja.

This image packages CMake releases from https://github.com/Kitware/CMake/releases
on Ubuntu 26.04, with GCC 15.2 from the Ubuntu archive.

Image source: https://github.com/boxcutter/oci/tree/main/cmake/gcc

## Tags

| Tag | Contents |
| --- | --- |
| `latest`, `4.4`, `4.4.5` | CMake 4.4.5 with GCC 15.2 on Ubuntu 26.04 |

## Building a project

Mount your source tree on `/src`, the default working directory, and run
`cmake` to configure and build it:

```bash
docker run -it --rm \
  --user "$(id -u):$(id -g)" \
  --mount type=bind,source="$(pwd)",target=/src \
  docker.io/boxcutter/cmake-gcc \
    bash -c "cmake -S . -B build && cmake --build build"
```

The build output goes to `build/` in your source tree. Passing `--user` keeps
the files owned by you instead of root.

To use Ninja instead of Make, pass `-G Ninja` when configuring, or set
`CMAKE_GENERATOR=Ninja`:

```bash
docker run -it --rm \
  --user "$(id -u):$(id -g)" \
  --mount type=bind,source="$(pwd)",target=/src \
  --env CMAKE_GENERATOR=Ninja \
  docker.io/boxcutter/cmake-gcc \
    bash -c "cmake -S . -B build && cmake --build build"
```

## CMake 4 and older projects

CMake 4 removed compatibility with versions older than 3.5. A project whose
`cmake_minimum_required` is below 3.5 fails to configure. Until the project is
updated, you can configure it anyway with
`-DCMAKE_POLICY_VERSION_MINIMUM=3.5`.

## License

CMake is licensed under the BSD 3-Clause License. The license is in the image
at `/opt/cmake/doc/cmake/LICENSE.rst`, with the licenses of the libraries CMake
bundles in the directories next to it.

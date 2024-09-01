# cmake-clang

CMake build system with clang compiler toolchain.

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/src \
  docker.io/boxcutter/cmake-gcc
  
```
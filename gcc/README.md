# GCC

The GNU Compiler Collection is a compiling system that supports several languages.

This image is based on https://github.com/docker-library/gcc

### Compiling your app inside of a container

To compile, but not run your app inside the Docker instance, you can write something like:

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/usr/src/myapp \
  --workdir /usr/src/myapp \
  docker.io/boxcutter/gcc:13 -std=c++17 -O2 myapp.c -o myapp -Wall
```

### Create a Containerfile in your app project

```
FROM docker.io/boxcutter/gcc:13

WORKDIR /usr/src/myapp

COPY . .
RUN gcc -o myapp main.c

CMD ["./myapp"]
```

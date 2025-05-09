# rust

Rust is a systems programming language sponsored by Mozilla Research. It is designed to be a "safe, concurrent, practical language", supporting functional and imperative-procedural paradigms. Rust is syntactically similar to C++, but is designed for better memory safety while maintaining performance.

This image packages releases from https://github.com/rust-lang/docker-rust

Image source: https://github.com/polymathrobotics/oci/tree/main/rust

## Using rust

The most straightforward way to use this image is to use a Rust container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

```
FROM rust:1.31

WORKDIR /usr/src/myapp
COPY . .

RUN cargo install --path .

CMD ["myapp"]
```

Then, build and run the Docker image:

```
$ docker build -t my-rust-app .
$ docker run -it --rm --name my-running-app my-rust-app
```

This creates an image that has all of the rust tooling for the image, which is 1.8gb. If you just want the compiled application:

```
FROM rust:1.40 as builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo install --path .

FROM debian:buster-slim
RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/myapp /usr/local/bin/myapp
CMD ["myapp"]
```

Note: Some shared libraries may need to be installed as shown in the installation of the extra-runtime-dependencies line above.

This method will create an image that is less than 200mb. If you switch to using the Alpine-based rust image, you might be able to save another 60mb.

See https://docs.docker.com/develop/develop-images/multistage-build/ for more information.

## Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```
$ docker run --rm \
    --user "$(id -u)":"$(id -g)" \
    --mount type=bind,source="$(pwd)",target="/usr/src/app" \
    --workdir /usr/src/app \
    docker.io/boxcutter/rust:slim-noble cargo build --release
```

This will add your current directory, as a volume, to the container, set the working directory to the volume, and run the command `cargo build --release`. This tells Cargo, Rust's build system, to compile the crate in `myapp` and output the executable to `target/release/myapp`.



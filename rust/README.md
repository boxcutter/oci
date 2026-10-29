# rust

Rust is a systems programming language originally developed at Mozilla Research and now stewarded by the Rust Foundation. It is designed to be a "safe, concurrent, practical language", supporting functional and imperative-procedural paradigms. Rust is syntactically similar to C++, but is designed for better memory safety while maintaining performance.

This image packages releases from https://github.com/rust-lang/docker-rust

Image source: https://github.com/boxcutter/oci/tree/main/rust

## Tags

| Tag | Contents |
| --- | --- |
| `slim`, `1-slim`, `1.99-slim`, `1.99.1-slim`, `slim-resolute`, `1-slim-resolute`, `1.99-slim-resolute`, `1.99.1-slim-resolute` | Rust 1.99.1 on Ubuntu 26.04 |
| `slim-noble`, `1-slim-noble`, `1.99-slim-noble`, `1.99.1-slim-noble` | Rust 1.99.1 on Ubuntu 24.04 |

The images use rustup's `minimal` profile, so they include `rustc`, `cargo`
and the standard library but not `rustfmt` or `clippy`. Add them with
`rustup component add rustfmt clippy`.

## Using rust

The most straightforward way to use this image is to use a Rust container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project:

```
FROM docker.io/boxcutter/rust:1.99-slim

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

This creates an image that has all of the Rust tooling, which is over 1GB. If you just want the compiled application:

```
FROM docker.io/boxcutter/rust:1.99-slim AS builder
WORKDIR /usr/src/myapp
COPY . .
RUN cargo install --path .

FROM docker.io/ubuntu:resolute
RUN apt-get update && apt-get install -y extra-runtime-dependencies && rm -rf /var/lib/apt/lists/*
COPY --from=builder /usr/local/cargo/bin/myapp /usr/local/bin/myapp
CMD ["myapp"]
```

Note: Some shared libraries may need to be installed as shown in the installation of the extra-runtime-dependencies line above.

Build on the same Ubuntu release you run on, so the binary links against a
matching glibc. Use the `-slim-noble` tags if your runtime image is Ubuntu
24.04.

See https://docs.docker.com/develop/develop-images/multistage-build/ for more information.

## Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```
$ docker run --rm \
    --user "$(id -u)":"$(id -g)" \
    --mount type=bind,source="$(pwd)",target="/usr/src/app" \
    --workdir /usr/src/app \
    docker.io/boxcutter/rust:slim cargo build --release
```

This will add your current directory, as a volume, to the container, set the working directory to the volume, and run the command `cargo build --release`. This tells Cargo, Rust's build system, to compile the crate in `myapp` and output the executable to `target/release/myapp`.

## License

Rust is dual-licensed under the MIT license and the Apache License, Version
2.0. The license files for the installed toolchain are under
`/usr/local/rustup/toolchains/*/share/doc/`.

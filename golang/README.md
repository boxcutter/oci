# golang

Go (a.k.a., Golang) is a programming language first developed at Google. It is a statically-typed language with syntax loosely derived from C, but with additional features such as garbage collection, type safety, some dynamic-typing capabilities, additional built-in types (e.g., variable-length arrays and key-value maps), and a large standard library.

This images packages releases from https://github.com/docker-library/golang

Image source: https://github.com/boxcutter/oci/tree/main/golang

## How to use this image

Note: `/go` is world-writable to allow flexibility in the user which runs the container (for example, in a container started with `--user 1000:1000`, running `go get github.com/example/...` into the default `$GOPATH` will succeed). While the `777` directory would be insecure on a regular host setup, there are not typically other processes or users inside the container, so this is equivalent to `700` for Docker usage, but allowing for `--user` flexibility.

### Start a Go instance in your app

The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project (assuming it uses `go.mod` for dependency management):

```
FROM golang:1.19-jammy

WORKDIR /usr/src/app

# pre-copy/cache go.mod for pre-downloading dependencies and only redownloading them in subsequent builds if they change
COPY go.mod go.sum ./
RUN go mod download && go mod verify

COPY . .
RUN go build -v -o /usr/local/bin/app ./...

CMD ["app"]
```

You can then build and run the Docker image:

```
$ docker build -t my-golang-app .
$ docker run -it --rm --name my-running-app my-golang-app
```

### Compile your app inside the Docker container

There may be occasions where it is not appropriate to run your app inside a container. To compile, but not run your app inside the Docker instance, you can write something like:

```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.19-jammy go build -v
```

This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `go build` which will tell go to compile the project in the working directory and output the executable to `myapp`. Alternatively, if you have a `Makefile`, you can run the `make` command inside your container.

```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.19-jammy make
```

### Cross-compile your app inside the Docker container

If you need to compile your application for a platform other than `linux/amd64` (such as `windows/386):

```
$ docker run --rm -v "$PWD":/usr/src/myapp -w /usr/src/myapp -e GOOS=windows -e GOARCH=386 golang:1.19-jammy go build -v
```

Alternatively, you can build for multiple platforms at once:

```
$ docker run --rm -it -v "$PWD":/usr/src/myapp -w /usr/src/myapp golang:1.19-jammy bash
$ for GOOS in darwin linux; do
>   for GOARCH in 386 amd64; do
>     export GOOS GOARCH
>     go build -v -o myapp-$GOOS-$GOARCH
>   done
> done
```
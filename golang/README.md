# golang

Go (a.k.a., Golang) is a programming language first developed at Google. It is a statically-typed language with syntax loosely derived from C, but with additional features such as garbage collection, type safety, some dynamic-typing capabilities, additional built-in types (e.g., variable-length arrays and key-value maps), and a large standard library.

This image packages releases from https://github.com/docker-library/golang

Image source: https://github.com/boxcutter/oci/tree/main/golang

## Tags

| Tag | Contents |
| --- | --- |
| `latest`, `1`, `1-resolute`, `1.27`, `1.27-resolute`, `1.27.3`, `1.27.3-resolute` | Go 1.27 on Ubuntu 26.04 |
| `1.26`, `1.26-resolute`, `1.26.10`, `1.26.10-resolute` | Go 1.26 on Ubuntu 26.04 |

Only the two newest Go releases are supported upstream, so older versions are
no longer built. Previously published tags such as `1.25-noble` remain on
Docker Hub but don't receive updates.

## How to use this image

Note: `/go` is world-writable to allow flexibility in the user which runs the container (for example, in a container started with `--user 1000:1000`, running `go get github.com/example/...` into the default `$GOPATH` will succeed). While the `777` directory would be insecure on a regular host setup, there are not typically other processes or users inside the container, so this is equivalent to `700` for Docker usage, but allowing for `--user` flexibility.

### Start a Go instance in your app

The most straightforward way to use this image is to use a Go container as both the build and runtime environment. In your `Dockerfile`, writing something along the lines of the following will compile and run your project (assuming it uses `go.mod` for dependency management):

```
FROM docker.io/boxcutter/golang:1.27

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
$ docker run --rm \
    --mount type=bind,source="$PWD",target=/code \
    --workdir /code \
    docker.io/boxcutter/golang:1.27 go build -v
```

This will add your current directory as a volume to the container, set the working directory to the volume, and run the command `go build` which will tell go to compile the project in the working directory and output the executable in it. Alternatively, if you have a `Makefile`, you can run the `make` command inside your container.

```
$ docker run --rm \
    --mount type=bind,source="$PWD",target=/code \
    --workdir /code \
    docker.io/boxcutter/golang:1.27 make
```

### Cross-compile your app inside the Docker container

If you need to compile your application for a platform other than `linux/amd64` (such as `windows/386`):

```
$ docker run --rm \
    --mount type=bind,source="$PWD",target=/code \
    --workdir /code \
    -e GOOS=windows \
    -e GOARCH=386 \
    docker.io/boxcutter/golang:1.27 go build -v
```

Alternatively, you can build for multiple platforms at once:

```
$ docker run --rm -it \
    --mount type=bind,source="$PWD",target=/code \
    --workdir /code \
    docker.io/boxcutter/golang:1.27 bash
$ for GOOS in darwin linux; do
>   for GOARCH in 386 amd64; do
>     export GOOS GOARCH
>     go build -v -o myapp-$GOOS-$GOARCH
>   done
> done
```

### Golang CLI

```
$ docker run -it --rm docker.io/boxcutter/golang:1.27 go
Go is a tool for managing Go source code.

Usage:

	go <command> [arguments]

The commands are:

	bug         start a bug report
	build       compile packages and dependencies
	clean       remove object files and cached files
	doc         show documentation for package or symbol
	env         print Go environment information
	fix         apply fixes suggested by static checkers
	fmt         gofmt (reformat) package sources
	generate    generate Go files by processing source
	get         add dependencies to current module and install them
	install     compile and install packages and dependencies
	list        list packages or modules
	mod         module maintenance
	run         compile and run Go program
	telemetry   manage telemetry data and settings
	test        test packages
	tool        run specified go tool
	version     print Go version
	vet         report likely mistakes in packages
	work        workspace maintenance

Use "go help <command>" for more information about a command.

Additional help topics:

	buildconstraint build constraints
	buildjson       build -json encoding
	buildmode       build modes
	c               calling between Go and C
	cache           build and test caching
	environment     environment variables
	filetype        file types
	goauth          GOAUTH environment variable
	go.mod          the go.mod file
	gopath          GOPATH environment variable
	goproxy         module proxy protocol
	importpath      import path syntax
	modules         modules, module versions, and more
	module-auth     module authentication using go.sum
	packages        package lists and patterns
	private         configuration for downloading non-public code
	testflag        testing flags
	testfunc        testing functions
	vcs             controlling version control with GOVCS

Use "go help <topic>" for more information about that topic.
```

## License

Go is licensed under the BSD 3-Clause License. The license ships in the image at
`/usr/local/go/LICENSE`.

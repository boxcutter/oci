# ruby

Ruby is a dynamic, reflective, object-oriented, general-purpose, open-source programming language.

This image packages releases from https://github.com/docker-library/ruby

# Using ruby

## Running the Ruby Read-Eval-Print Loop (REPL)

The Ruby REPL is called irb and is the default command running in this image:

```
docker run -it --rm \
  docker.io/boxcutter/ruby
```

## Run a single Ruby script

For many simple, single file projects, you can run a Ruby script by using the container image directly:

```
docker run -it --rm \
  --name my-running-script \
  --mount type=bind,source="$(pwd)",target=/usr/src/myapp \
  --workdir /usr/src/myapp \
  docker.io/boxcutter/ruby:3.1 your-daemon-or-script.rb
```

## Package your Ruby app into a container image

### Create a `Containerfile` in your Ruby app project

```
FROM docker.io/boxcutter/ruby:3.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

CMD ["./your-daemon-or-script.rb"]
```

Put this file in the root of your app, next to your `Gemfile`.

You can then build and run the Ruby image:

```
$ docker build -f Containerfile -t my-ruby-app .
$ docker run -it --name my-running-script my-ruby-app
```

### Generate a `Gemfile.lock`

The above example `Containerfile` expects a `Gemfile.lock` in your app directory. This `docker run` will help you generate one. Run it in the root of your app, next to the `Gemfile`:

```
$ docker run --rm -v "$PWD":/usr/src/app -w /usr/src/app docker.io/boxcutter/ruby:3.1 bundle install
```

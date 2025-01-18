# node

This image packages releases from: https://github.com/nodejs/docker-node

## Using Node.JS


### Running the node Read-Eval-Print Loop (REPL)

The Node.JS REPL is the default command running in this image:
```
docker run -it --rm \
  docker.io/boxcutter/node:22-noble-slim
```

# Running a single Node.js script

```
docker run -it --rm \
  --name my-running script \
  --mount type=bind,source="$(pwd)",target="/usr/src/app" \
  --workdir /usr/src/app \
  docker.io/boxcutter/node:22-noble-slim node your-daemon-or-script.js
```

# node

# Based on docker-node
# https://github.com/nodejs/docker-node

# Running a single Node.js script

```
docker run -it --rm \
  --name my-running script \
  --mount type=bind,source="$(pwd)",target="/usr/src/app" \
  --workdir /usr/src/app \
  docker.io/boxcutter/node:21-jammy node your-daemon-or-script.js
```

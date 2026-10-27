# promptfoo

Promptfoo is a tool for testing, evaluating and red-teaming LLM apps.

This image packages promptfoo releases from npm: https://github.com/promptfoo/promptfoo

Based on https://github.com/promptfoo/promptfoo/blob/main/Dockerfile, but
installs the published npm package on top of `docker.io/boxcutter/node`
instead of building from source on Alpine.

Image source: https://github.com/boxcutter/oci/tree/main/promptfoo

# Running the web server

By default, the container starts the self-hosted promptfoo server on port 3000.
Mount a volume on `/home/promptfoo/.promptfoo` to keep the database between
runs:

```bash
docker run -it --rm \
  --mount type=volume,source=promptfoo,target=/home/promptfoo/.promptfoo \
  --publish 3000:3000 \
  docker.io/boxcutter/promptfoo
# Browse to http://localhost:3000/
```

# Running evals

The container's working directory is `/promptfoo`. Bind mount a project
directory there and pass any `promptfoo` command, along with the API keys
your providers need:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/promptfoo \
  --env OPENAI_API_KEY \
  docker.io/boxcutter/promptfoo \
    promptfoo eval
```

To create a new project:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/promptfoo \
  docker.io/boxcutter/promptfoo \
    promptfoo init --no-interactive
```

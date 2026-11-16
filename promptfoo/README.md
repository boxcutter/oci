# promptfoo

Promptfoo is a tool for testing, evaluating and red-teaming LLM apps.

This image packages promptfoo releases from npm: https://github.com/promptfoo/promptfoo

Based on https://github.com/promptfoo/promptfoo/blob/main/Dockerfile, but
installs the published npm package on top of `docker.io/boxcutter/node`
instead of building from source on Alpine. The install runs `npm ci` from the
committed `package-lock.json`, so every dependency is pinned. The `overrides`
in `package.json` move dependencies with known advisories to fixed releases.

Image source: https://github.com/boxcutter/oci/tree/main/promptfoo

# Running the web server

By default, the container starts the self-hosted promptfoo server on port 3000.
Mount a volume on `/home/promptfoo/.promptfoo` to keep the database between
runs.

The server has no authentication, so anyone who can reach the port can read
your eval results. Publish it on localhost only, unless something in front of
it handles authentication:

```bash
docker run -it --rm \
  --mount type=volume,source=promptfoo,target=/home/promptfoo/.promptfoo \
  --publish 127.0.0.1:3000:3000 \
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

# Updating promptfoo

1. Set the new version in `package.json` and as `VERSION` in
   `docker-bake.hcl`. The build fails if they differ.
2. Check whether each entry in `overrides` is still needed. Remove an
   override once promptfoo's own dependency range picks up the fixed release.
3. Regenerate `package-lock.json` with the npm from the base image:

   ```bash
   docker run --rm --user root --entrypoint bash \
     --mount type=bind,source="$(pwd)",target=/w --workdir /w \
     docker.io/boxcutter/node:24-resolute-slim \
     -c 'npm install --package-lock-only --ignore-scripts --no-audit --no-fund && chown "$(stat -c %u:%g package.json)" package-lock.json'
   ```

4. Review the lockfile diff. Every changed dependency arrives through it.
5. Check what is still flagged:

   ```bash
   docker run --rm --entrypoint bash \
     --mount type=bind,source="$(pwd)",target=/w,readonly --workdir /w \
     docker.io/boxcutter/node:24-resolute-slim \
     -c 'npm audit --omit=dev'
   ```

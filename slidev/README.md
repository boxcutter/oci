# slidev

Based on https://github.com/tangramor/slidev_docker/blob/master/Dockerfile

# Creating a slideshow project

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --publish 3030:3030 \
  --entrypoint /bin/bash \
  docker.io/boxcutter/slidev \
    -c "echo n | npm init slidev@latest --yes my-project"
```

# Viewing the slideshow

```bash
cd my-project
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --publish 3030:3030 \
  docker.io/boxcutter/slidev
# Browse to http://localhost:3030/
```

On the first run, the container installs the dependencies listed in
`package.json` and writes a `package-lock.json`. Later runs reuse
`node_modules` and only reinstall when `package.json` or `package-lock.json`
changes. Starting the container never upgrades Slidev. Commit
`package-lock.json` to keep the same versions everywhere.

If the directory has no `package.json`, the container installs the latest
Slidev and creates one. If there is no `slides.md`, it creates one from the
Slidev template.

Any arguments are passed to the `slidev` command. The default is `--remote`.
For example, to export to PDF:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  docker.io/boxcutter/slidev export
```

# Updating Slidev

Updating is a deliberate step that changes `package.json` and
`package-lock.json`. To see what is out of date:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --entrypoint npm \
  docker.io/boxcutter/slidev \
    outdated
```

To upgrade Slidev and the themes to their latest versions:

```bash
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --entrypoint npm \
  docker.io/boxcutter/slidev \
    install @slidev/cli@latest @slidev/theme-default@latest @slidev/theme-seriph@latest
```

Add any other themes or add-ons in your `package.json` to the same command.
To take only the minor and patch updates allowed by the ranges in
`package.json`, run `npm update` instead.

`node_modules` holds Linux binaries built for the container, so don't share
it with `npm` on a macOS or Windows host. Delete `node_modules` if you switch
between the two.

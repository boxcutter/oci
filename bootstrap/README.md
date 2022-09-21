# bootstrap

The images in this subdirectory are needed to bootstrap the build system. The scripts in the `/bin` directory reference these images:
- cinc-auditor
- dasel
- hadolint

If you happen to want to transplant this repo to your local environment and customize it for your purposes, just make sure you bootstrap the system by making sure these images are published to a container repo.

This is how we bootstrapped the current images. This only need to be done once, then after that point you can use the build system to update everything. Just make sure you publish new bootstrap images before updating the references in the build scripts in bin.

```bash
# Publish dasel
# Needed by image-name.sh, list-platforms.sh, and list-tags.sh to grab parameters from Polly.toml
cd $(git rev-parse --show-toplevel)/src/bootstrap/dasel
docker buildx build \
  --platform linux/arm64,linux/amd64,linux/arm/v7 \
  --file Containerfile \
  --tag docker.io/polymathrobotics/dasel:1.26.1 \
  --push \
  .

# Publish hadolint
# Needed by lint.sh to lint Containerfiles
cd $(git rev-parse --show-toplevel)/src/bootstrap/hadolint
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --file Containerfile \
  --tag docker.io/polymathrobotics/dasel:2.10.0 \
  --push \
  .

# Publish cinc-auditor
# Needed by test.sh to run InSpec tests
cd $(git rev-parse --show-toplevel)/src/bootstrap/cinc-auditor
docker buildx build \
  --platform linux/arm64,linux/amd64 \
  --file Containerfile \
  --tag docker.io/polymathrobotics/cinc-auditor:5.14.0 \
  --push \
  .
```

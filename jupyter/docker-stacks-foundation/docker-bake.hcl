variable "IMAGE_NAME" {
  default = "jupyter-docker-stacks-foundation"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:python-3.11.7",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:python-3.11",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:ubuntu-22.04",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Basis for all other stacks on which Jupyter-related applications can be built."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "jupyter/README.md"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

variable "IMAGE_NAME" {
  default = "hadolint"
}

variable "VERSION" {
  default = "2.12.0"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

# Special target: https://github.com/docker/metadata-action#bake-definition
target "docker-metadata-action" { }

target "_common" {
  inherits = ["docker-metadata-action"]
  dockerfile = "Containerfile"
  tags = [
    # docker.io/boxcuter/hadolint:x.x.x
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
}

target "lint" {
  dockerfile = "Containerfile"
  target = "lint"
  output = ["type=cacheonly"]
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

group "default" {
  targets = ["lint", "release"]
}

target "release" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Dockerfile linter, validate inline bash, written in Haskell." 
  }
}

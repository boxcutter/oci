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

target "_common" {
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
}

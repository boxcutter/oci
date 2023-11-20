variable "IMAGE_NAME" {
  default =  "buildpack-deps"
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
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "A collection of common build dependencies used for installing various modules."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
  }
}

target "curl" {
  inherits = ["_common"]
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy-curl",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04-curl"
  ]
  # platforms = ["${LOCAL_PLATFORM}"]
}

target "scm" {
  inherits = ["_common"]
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy-scm",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04-scm"
  ]  
  # platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04"
  ]  
}

group "local" {
  targets = ["curl", "scm", "default"]
  platforms = ["${LOCAL_PLATFORM}"]
}

group "default" {
  targets = ["curl", "scm", "default"]
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/arm/v7"]
}

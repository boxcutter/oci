variable "IMAGE_NAME" {
  default = "buildpack-deps"
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
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "A collection of common build dependencies used for installing various modules."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy-curl",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04-curl"
  ]
}

target "scm" {
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "A collection of common build dependencies used for installing various modules."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy-scm",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04-scm"
  ]  
}

target "default" {
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "A collection of common build dependencies used for installing various modules."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:22.04"
  ]  
}

target "local-curl" {
  inherits = ["curl"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "local-scm" {
  inherits = ["scm"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "local-default" {
  inherits = ["default"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "release-curl" {
  inherits = ["curl"]
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/arm/v7"]
}

target "release-scm" {
  inherits = ["scm"]
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/arm/v7"]
}

target "release-default" {
  inherits = ["default"]
  platforms = ["linux/amd64", "linux/arm64/v8", "linux/arm/v7"]
}

group "local" {
  targets = ["local-curl", "local-scm", "local-default"]
}

group "default" {
  targets = ["release-curl", "release-scm", "release-default"]
}

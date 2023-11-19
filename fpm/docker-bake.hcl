variable "IMAGE_NAME" {
  default = "fpm"
}

variable "VERSION" {
  default = "1.15.1"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

variable "LOCAL_PLATFORM" {
  default="${BAKE_LOCAL_PLATFORM}" == "darwin/arm64/v8" ? "linux/arm64/v8" : "${BAKE_LOCAL_PLATFORM}"
}

target "_common" {
  args = {
    FPM_VERSION = "${VERSION}"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Packaging made simple."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
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

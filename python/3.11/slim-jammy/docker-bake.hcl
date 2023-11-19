variable "IMAGE_NAME" {
  default = "python"
}

variable "VERSION" {
  default = "3.11.6"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

variable "LOCAL_PLATFORM" {
  default="${BAKE_LOCAL_PLATFORM}" == "darwin/arm64/v8" ? "linux/arm64/v8" : "${BAKE_LOCAL_PLATFORM}"
}

target "_common" {
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-slim-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:3.8-slim-jammy",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/polymathrobotics/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Python is an interpreted, interactive, object-oriented, open-source programming language."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.polymathrobotics.image.readme-filepath" = "python/README.md"
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

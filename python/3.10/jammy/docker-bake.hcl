variable "IMAGE_NAME" {
  default = "python"
}

variable "VERSION" {
  default = "3.10.13"
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
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:3.10-jammy",
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

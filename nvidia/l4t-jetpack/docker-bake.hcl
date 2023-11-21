variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

variable "IMAGE_NAME" {
  default = "nvidia-l4t-jetpack"
}

target "default" {
  name = "${IMAGE_NAME}-${replace(tag, ".", "-")}"
  args = {
    TAG = tag
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:r${tag}"
  ]
  dockerfile = "Containerfile"
  platforms = ["linux/arm64/v8"]
  labels = {
    "org.opencontainers.image.created" = timestamp()
    "org.opencontainers.image.description" = "NVIDIA JetPack SDK."
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
  }
  matrix = {
    tag = ["35.3.1", "35.4.1"]
  }
}
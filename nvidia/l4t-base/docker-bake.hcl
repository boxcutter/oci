variable "TAG_PREFIX" {
  default =  "docker.io/boxcutter/nvidia-l4t-base"
}

variable "IMAGE_NAME" {
  default = "nvidia-l4t-base"
}

target "default" {
  name = "${IMAGE_NAME}-${replace(item.version, ".", "-")}"
  target = "nvidia-l4t-base"
  args = {
    RELEASE = item.release
  }
  tags = [
    "${TAG_PREFIX}:${item.version}"
  ]
  dockerfile = item.dockerfile
  platforms = ["linux/arm64/v8"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Linux for Tegra (L4T) base image for the NVIDIA Jetson embedded computing platform."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = timestamp()
  }
  matrix = {
    item = [
      { version = "35.3.1", release = "r35.3", dockerfile = "Containerfile.r35" },
      { version = "35.4.1", release = "r35.4", dockerfile = "Containerfile.r35" },
      { version = "36.2.0", release = "r36.2", dockerfile = "Containerfile.r36" },
    ]
  }
}

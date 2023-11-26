variable "IMAGE_NAME" {
  default =  "node_exporter"
}

variable "VERSION" {
  default = "1.5.0"
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
  args = {
    NODE_EXPORTER_URL_AMD64 = "https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-amd64.tar.gz"
    NODE_EXPORTER_SHA256_AMD64 = "af999fd31ab54ed3a34b9f0b10c28e9acee9ef5ac5a5d5edfdde85437db7acbb"
    NODE_EXPORTER_URL_ARM64 = "https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-arm64.tar.gz"
    NODE_EXPORTER_SHA256_ARM64 = "e031a539af9a619c06774788b54c23fccc2a852d41437315725a086ccdb0ed16"
    NODE_EXPORTER_URL_ARMHF = "https://github.com/prometheus/node_exporter/releases/download/v1.5.0/node_exporter-1.5.0.linux-armv7.tar.gz"
    NODE_EXPORTER_SHA256_ARMHF = "27d8853a3f2d131f97f3817761bd0714582482c97cafa2f27689fc7e9f30d9cc"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Prometheus node exporter for machine metrics."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "prometheus/node_exporter/README.md"
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

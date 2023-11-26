variable "IMAGE_NAME" {
  default =  "blackbox_exporter"
}

variable "VERSION" {
  default = "0.24.0"
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
    BLACKBOX_EXPORTER_URL_AMD64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-amd64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_AMD64 = "81b36cece040491ac0d9995db2a0964c40e24838a03a151c3333a7dc3eef94ff"
    BLACKBOX_EXPORTER_URL_ARM64 = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-arm64.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARM64 = "acbbedf03de862fa833bc4dd810e63f105cb44e47abf493192fce3451852dc58"
    BLACKBOX_EXPORTER_URL_ARMHF = "https://github.com/prometheus/blackbox_exporter/releases/download/v0.24.0/blackbox_exporter-0.24.0.linux-armv7.tar.gz"
    BLACKBOX_EXPORTER_SHA256_ARMHF = "13b6652f69b6ab3d0f84440a893446679662c6f8b4cca360363c41baa4028638"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Blackbox exporter for probing remote machine metrics."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "prometheus/blackbox_exporter/README.md"
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

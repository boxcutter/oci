variable "IMAGE_NAME" {
  default = "boxcutter/cinc-auditor"
}

variable "VERSION" {
  default = "6.8.1"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc-auditor/6.8.1/ubuntu/24.04/cinc-auditor_6.8.1-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "a374920fad620aa5c738592bac14e6c31b876615f8566943b5f049a16296a483"
    CINC_AUDITOR_URL_ARM64 = "http://ftp.osuosl.org/pub/cinc/files/stable/cinc-auditor/6.8.1/ubuntu/24.04/cinc-auditor_6.8.1-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "d32c1b8b6bd45ed44b434512b39f29b42819393960cfee2cb70fe50a17d04097"
    CONTAINER_REGISTRY = "${CONTAINER_REGISTRY}"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Cinc Auditing and Testing Framework."
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

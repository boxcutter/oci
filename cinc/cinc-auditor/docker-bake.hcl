variable "IMAGE_NAME" {
  default = "cinc-auditor"
}

variable "VERSION" {
  default = "6.6.0"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    CINC_AUDITOR_URL_AMD64 = "http://downloads.cinc.sh/files/stable/cinc-auditor/6.6.0/ubuntu/22.04/cinc-auditor_6.6.0-1_amd64.deb"
    CINC_AUDITOR_SHA256_AMD64 = "f92ad5ba73bb3095521b455dcb99cd002c04e2e8a19e1b2344439c6d1fc41901"
    CINC_AUDITOR_URL_ARM64 = "http://downloads.cinc.sh/files/stable/cinc-auditor/6.6.0/ubuntu/22.04/cinc-auditor_6.6.0-1_arm64.deb"
    CINC_AUDITOR_SHA256_ARM64 = "5b916b629315d5a3324313bb521e6fabacfd36e45a1d065ccb89e494dbf98512"
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

variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/jsonnet"
}

variable "VERSION" {
  default = "0.22.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    JSONNET_URL_AMD64 = "https://github.com/google/go-jsonnet/releases/download/v0.22.0/go-jsonnet_0.22.0_linux_amd64.tar.gz"
    JSONNET_SHA256_AMD64 = "e87a93ea44e34da92c15636205c7f2240bf3ac92d00ccb855dbb4e7e03ea6941"
    JSONNET_URL_ARM64 = "https://github.com/google/go-jsonnet/releases/download/v0.22.0/go-jsonnet_0.22.0_linux_arm64.tar.gz"
    JSONNET_SHA256_ARM64 = "3016b049254cb92548ba99304b6f44ec3795e6173f908e3ce3c5add57243fe20"
    # mixtool has no releases, so pin a commit on main
    MIXTOOL_VERSION = "496ea9a28ba9134279ae54b2b3379d68da40a364"
  }
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Jsonnet utilities."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
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

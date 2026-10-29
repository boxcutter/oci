variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/doctl"
}

variable "VERSION" {
  default = "2.1.0"
}

variable "KUBECTL_VERSION" {
  default = "1.37.2"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  args = {
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v${VERSION}/doctl-${VERSION}-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "e9d0488c56cfe6369d3310a14e14b0a6cd71a37091503d016d28e31630ee3010"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v${VERSION}/doctl-${VERSION}-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "0b4cb4dad8aa54f74bd422367c895c3022e74da80eca6331538024c35d7cf39f"
    KUBECTL_URL_AMD64 = "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    KUBECTL_SHA256_AMD64 = "c04487523e7aa7d1493f7808174c899db93d7a9cf57531420cd76b9bd415f8f4"
    KUBECTL_URL_ARM64 = "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"
    KUBECTL_SHA256_ARM64 = "fcc16f63186659d9722014b7e02d5fdd2d4e669cb8c0ab66365d7d3b8ba03509"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Digital Ocean command-line interface."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "doctl/README.md"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64"]
}

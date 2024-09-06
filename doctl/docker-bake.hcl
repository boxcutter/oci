variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/doctl"
}

variable "VERSION" {
  default = "1.112.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.112.0/doctl-1.112.0-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "1040b6ec998a2393556d91050168e58b65405c951041c6ec7447bb0e487c1d04"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.112.0/doctl-1.112.0-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "39fcaec4ad0c1ca680eb44e37eab230ed6a88ac05098993453d5e711215132de"
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

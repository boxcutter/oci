variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/doctl"
}

variable "VERSION" {
  default = "1.141.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.141.0/doctl-1.141.0-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "72045e8e6fc16a5e52eaf3ceef8c5cbe92f6ba2d02e3ed79996f3125f4efd932"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.141.0/doctl-1.141.0-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "97e3b2977947a96bd23e502b02b377b953a777f786d535749b2d3f3ac36ce661"
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

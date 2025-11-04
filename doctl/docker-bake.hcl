variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/doctl"
}

variable "VERSION" {
  default = "1.146.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.146.0/doctl-1.146.0-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "ef16a6f9e4e3eb6f1a5f34218819f3443f67b54c567a3de9e06a4caec6d0d0d8"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.146.0/doctl-1.146.0-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "09f5b36471ae820d45d436b92d59f4170eae48074771e0356a0df56cffa94020"
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

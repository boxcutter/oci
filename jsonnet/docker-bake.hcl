variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/jsonnet"
}

variable "VERSION" {
  default = "0.21.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    JSONNET_URL_AMD64 = "https://github.com/google/go-jsonnet/releases/download/v0.21.0/go-jsonnet_Linux_x86_64.tar.gz"
    JSONNET_SHA256_AMD64 = "ad3181fde77726b02d17eb4e72687020bf2cb35b9336cdeaaca4783c7ff104f7"
    JSONNET_URL_ARM64 = "https://github.com/google/go-jsonnet/releases/download/v0.21.0/go-jsonnet_Linux_arm64.tar.gz"
    JSONNET_SHA256_ARM64 = "4a263da605dbe2edb99529f495266211062fac476789f2119408bc223338f1d6"
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

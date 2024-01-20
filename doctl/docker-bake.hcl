variable "IMAGE_NAME" {
  default = "doctl"
}

variable "VERSION" {
  default = "1.103.0"
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
    DOCTL_URL_AMD64 = "https://github.com/digitalocean/doctl/releases/download/v1.103.0/doctl-1.103.0-linux-amd64.tar.gz"
    DOCTL_SHA256_AMD64 = "14c9f6984299a80ad3fbe8e9711d503667c203e2768c04cdcde8dcf4a61ca8fe"
    DOCTL_URL_ARM64 = "https://github.com/digitalocean/doctl/releases/download/v1.103.0/doctl-1.103.0-linux-arm64.tar.gz"
    DOCTL_SHA256_ARM64 = "e8f923281c274bbc1a60c8ade8a8b5beeb6d9832e8257eeb34a5413e5d8a1ae4"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Digital Ocean command-line interface."
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

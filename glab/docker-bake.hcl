variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/glab"
}

variable "VERSION" {
  default = "1.50.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    GLAB_URL_AMD64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.50.0/downloads/glab_1.50.0_linux_amd64.deb"
    GLAB_SHA256_AMD64 = "15bd7b19ea416091dae4adc6578ef39df88020044136c0de23fc2315d3b0e9ee"
    GLAB_URL_ARM64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.50.0/downloads/glab_1.50.0_linux_arm64.deb"
    GLAB_SHA256_ARM64 = "0caa82900bb0719a6dfe8f40a4060a02b68ed88ba689e7b0a4c811f91ed16f5a"
    DOCKER_URL_AMD64 = "https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz"
    DOCKER_URL_ARM64 = "https://download.docker.com/linux/static/stable/aarch64/docker-27.3.1.tgz"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "The GitLab CLI tool."
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

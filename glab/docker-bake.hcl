variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/glab"
}

variable "VERSION" {
  default = "1.59.2"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    GLAB_URL_AMD64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.59.2/downloads/glab_1.59.2_linux_amd64.deb"
    GLAB_SHA256_AMD64 = "7ddf678cc65044bcb5b7ad5622cec28a6a9a72449c1fecc0e34cc228c23f594c"
    GLAB_URL_ARM64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.59.2/downloads/glab_1.59.2_linux_arm64.deb"
    GLAB_SHA256_ARM64 = "8ac8b7f965269d95fb7041f99a9cdc6ffbf1860f07973e47f7ef5535f7dd3b6b"
    DOCKER_URL_AMD64 = "https://download.docker.com/linux/static/stable/x86_64/docker-28.2.2.tgz"
    DOCKER_URL_ARM64 = "https://download.docker.com/linux/static/stable/aarch64/docker-28.2.2.tgz"
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

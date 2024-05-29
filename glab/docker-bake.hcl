variable "IMAGE_NAME" {
  default = "glab"
}

variable "VERSION" {
  default = "1.41.0"
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
    MDL_VERSION = "${VERSION}"
    GLAB_URL_AMD64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.41.0/downloads/glab_1.41.0_Linux_x86_64.deb"
    GLAB_SHA256_AMD64 = "209c440be48f0c7ce959cb59ebe47d4791ca49da1b4703174645cf4c6445bc08"
    GLAB_URL_ARM64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.41.0/downloads/glab_1.41.0_Linux_arm64.deb"
    GLAB_SHA256_ARM64 = "fb9f4e4914e0824459a4e9614d29f430745ccf3d02190505e65ad056f38a8ed8"
    GLAB_URL_ARMHF = "https://gitlab.com/gitlab-org/cli/-/releases/v1.41.0/downloads/glab_1.41.0_Linux_arm.deb"
    GLAB_SHA256_ARMHF = "3239403030971f93be0f54c2a2103221cd23e44449abf741dff24d99d2cb404f"
    DOCKER_URL_AMD64 = "https://download.docker.com/linux/static/stable/x86_64/docker-26.1.0.tgz"
    DOCKER_URL_ARM64 = "https://download.docker.com/linux/static/stable/aarch64/docker-26.1.0.tgz"
    DOCKER_URL_ARMHF = "https://download.docker.com/linux/static/stable/armhf/docker-26.1.0.tgz"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "The GitLab CLI tool."
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

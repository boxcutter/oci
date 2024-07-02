variable "IMAGE_NAME" {
  default = "glab"
}

variable "VERSION" {
  default = "1.43.0"
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
    GLAB_URL_AMD64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.43.0/downloads/glab_1.43.0_Linux_x86_64.deb"
    GLAB_SHA256_AMD64 = "a2e93b8afc029ca580c206911eb9edd9ec0ed1a70ad138e47380f0aebb0a67b4"
    GLAB_URL_ARM64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.43.0/downloads/glab_1.43.0_Linux_arm64.deb"
    GLAB_SHA256_ARM64 = "fb35cadf249f002b8eb62214413b9bc1e61a6b84ecde6b301979c9a44a68a421"
    GLAB_URL_ARMHF = "https://gitlab.com/gitlab-org/cli/-/releases/v1.43.0/downloads/glab_1.43.0_Linux_arm.deb"
    GLAB_SHA256_ARMHF = "a8d6e5f623196d43e844632521306a0d5eff4873276d9178b88a9cc92449f442"
    DOCKER_URL_AMD64 = "https://download.docker.com/linux/static/stable/x86_64/docker-27.0.3.tgz"
    DOCKER_URL_ARM64 = "https://download.docker.com/linux/static/stable/aarch64/docker-27.0.3.tgz"
    DOCKER_URL_ARMHF = "https://download.docker.com/linux/static/stable/armhf/docker-27.0.3.tgz"
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

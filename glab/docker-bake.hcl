variable "IMAGE_NAME" {
  default = "glab"
}

variable "VERSION" {
  default = "1.40.0"
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
    GLAB_URL_AMD64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.40.0/downloads/glab_1.40.0_Linux_x86_64.deb"
    GLAB_SHA256_AMD64 = "1ada02415037bca72977418b3c830a75fe08f783dc0e0e5af1b425fafa4feaa2"
    GLAB_URL_ARM64 = "https://gitlab.com/gitlab-org/cli/-/releases/v1.40.0/downloads/glab_1.40.0_Linux_arm64.deb"
    GLAB_SHA256_ARM64 = "8ed63d7478e04dcbd2e9cdf590c0840fb974960de5ddd2fc48e33d71c66d8a83"
    GLAB_URL_ARMHF = "https://gitlab.com/gitlab-org/cli/-/releases/v1.40.0/downloads/glab_1.40.0_Linux_arm.deb"
    GLAB_SHA256_ARMHF = "dec70000dc555c73748462bbe2213ad1870beef4e709cf1e565c1a56de2ecba9"
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

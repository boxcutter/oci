variable "IMAGE_NAME" {
  default = "redis"
}

variable "VERSION" {
  default = "6.2.14"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  args = {
    REDIS_VERSION = "${VERSION}"
    REDIS_DOWNLOAD_URL = "http://download.redis.io/releases/redis-6.2.14.tar.gz"
    REDIS_DOWNLOAD_SHA = "34e74856cbd66fdb3a684fb349d93961d8c7aa668b06f81fd93ff267d09bc277"
  }
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-jammy"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Redis is an open source key-value store that functions as a data structure server."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "redis/README.md"
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

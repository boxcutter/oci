variable "IMAGE_NAME" {
  default = "ruby"
}

variable "VERSION" {
  default = "3.3.0"
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
    RUBY_VERSION = "${VERSION}"
    RUBY_DOWNLOAD_URL = "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.xz"
    RUBY_DOWNLOAD_SHA256 = "676b65a36e637e90f982b57b059189b3276b9045034dcd186a7e9078847b975b"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:slim-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:3-slim-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-slim-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-slim-jammy",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Ruby is a dynamic, reflective, object-oriented, general-purpose, open-source programming language."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "dev.boxcutter.image.readme-filepath" = "ruby/README.md"
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

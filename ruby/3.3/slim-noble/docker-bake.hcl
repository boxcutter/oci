variable "IMAGE_NAME" {
  default = "ruby"
}

variable "VERSION" {
  default = "3.3.4"
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
    RUBY_DOWNLOAD_URL = "https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.4.tar.xz"
    RUBY_DOWNLOAD_SHA256 = "1caaee9a5a6befef54bab67da68ace8d985e4fb59cd17ce23c28d9ab04f4ddad"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:slim-noble",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:3-slim-noble",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-slim-noble",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-slim-noble",
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

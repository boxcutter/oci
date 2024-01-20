variable "IMAGE_NAME" {
  default = "ruby"
}

variable "VERSION" {
  default = "3.2.3"
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
    RUBY_DOWNLOAD_URL = "https://cache.ruby-lang.org/pub/ruby/3.2/ruby-3.2.3.tar.xz"
    RUBY_DOWNLOAD_SHA256 = "cfb231954b8c241043a538a4c682a1cca0b2016d835fee0b9e4a0be3ceba476b"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:3-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}-jammy",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-jammy",
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

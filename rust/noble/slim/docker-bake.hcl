variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/rust"
}

variable "VERSION" {
  default = "1.99.1"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  args = {
    RUST_VERSION = "${VERSION}"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}-slim-noble",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-slim-noble",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 1))}-slim-noble",
    "${TAG_PREFIX}:slim-noble",
  ]

  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "MIT OR Apache-2.0"
    "org.opencontainers.image.description" = "Rust is a systems programming language focused on safety, speed, and concurrency."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "rust/README.md"
  }
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64"]
}

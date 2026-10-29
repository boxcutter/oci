variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/golang"
}

variable "VERSION" {
  default = "1.26.10"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}-resolute",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}-resolute",
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "BSD-3-Clause"
    "org.opencontainers.image.description" = "Go (golang) is a general purpose, higher-level, imperative programming language."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "golang/README.md"
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

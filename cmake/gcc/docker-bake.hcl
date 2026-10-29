variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cmake-gcc"
}

variable "VERSION" {
  default = "4.4.5"
}

# There's no darwin-based Docker, so if we're running on macOS, use linux
# The Windows images are too big and slow to be usable, instead use linux
variable "LOCAL_PLATFORM" {
  default = regex_replace(BAKE_LOCAL_PLATFORM, "^(darwin|windows)", "linux")
}

target "_common" {
  args = {
    CMAKE_URL_AMD64 = "https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}-linux-x86_64.tar.gz"
    CMAKE_SHA256_AMD64 = "ed85135c5a5135b45e50423cb406dea04ca3338da0b8ef3c9ede963559680be0"
    CMAKE_URL_ARM64 = "https://github.com/Kitware/CMake/releases/download/v${VERSION}/cmake-${VERSION}-linux-aarch64.tar.gz"
    CMAKE_SHA256_ARM64 = "301d5063ab259577c1b57ce5490b1aab9ea5c56dc4c822f73499553dab94925f"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}",
    "${TAG_PREFIX}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "BSD-3-Clause"
    "org.opencontainers.image.description" = "The CMake build tool with the GCC toolchain."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "cmake/gcc/README.md"
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

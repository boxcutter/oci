variable "TAG_PREFIX" {
  default =  "docker.io/boxcutter/uv"
}

variable "VERSION" {
  default = "0.7.19"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    UV_URL_AMD64 = "https://github.com/astral-sh/uv/releases/download/0.7.19/uv-i686-unknown-linux-gnu.tar.gz"
    UV_SHA256_AMD64 = "1785537fc65a35609dc33063b5f1cc85437a08ade4c0a832071c018481afe515"
    UV_URL_ARM64 = "https://github.com/astral-sh/uv/releases/download/0.7.19/uv-aarch64-unknown-linux-gnu.tar.gz"
    UV_SHA256_ARM64 = "31b81b4b4ecd51ee4202f1e710fc22b72666f716ffbb825aa397c8246624d60f"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:${join(".", slice(split(".", "${VERSION}"), 0, 2))}",
    "${TAG_PREFIX}:latest"
  ]
}

target "local" {
  inherits = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "uv is a Python package and project manager, by Astral"
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
  }
}

variable "TAG_PREFIX" {
  default =  "docker.io/boxcutter/uv"
}

variable "VERSION" {
  default = "0.9.21"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    UV_URL_AMD64 = "https://github.com/astral-sh/uv/releases/download/0.9.21/uv-x86_64-unknown-linux-musl.tar.gz"
    UV_SHA256_AMD64 = "7abc29b3a06a99fb23564400fe884f5798a1786dc2ca05b6e0f70c53de748ab2"
    UV_URL_ARM64 = "https://github.com/astral-sh/uv/releases/download/0.9.21/uv-aarch64-unknown-linux-musl.tar.gz"
    UV_SHA256_ARM64 = "03a49fb609888032dbc3be9fd114b50fc9bce8b73b3df319746ae08d1fbdea83"
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

variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/actionlint"
}

variable "VERSION" {
  default = "1.7.7"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    ACTIONLINT_URL_AMD64 = "https://github.com/rhysd/actionlint/releases/download/v1.7.7/actionlint_1.7.7_linux_amd64.tar.gz"
    ACTIONLINT_SHA256_AMD64 = "023070a287cd8cccd71515fedc843f1985bf96c436b7effaecce67290e7e0757"
    ACTIONLINT_URL_ARM64 = "https://github.com/rhysd/actionlint/releases/download/v1.7.7/actionlint_1.7.7_linux_arm64.tar.gz"
    ACTIONLINT_SHA256_ARM64 = "401942f9c24ed71e4fe71b76c7d638f66d8633575c4016efd2977ce7c28317d0"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/actionlint"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Static checker for GitHub Actions workflow files." 
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
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

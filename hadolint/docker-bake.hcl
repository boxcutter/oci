variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/hadolint"
}

variable "VERSION" {
  default = "2.14.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    HADOLINT_URL_AMD64 = "https://github.com/hadolint/hadolint/releases/download/v2.14.0/hadolint-linux-x86_64"
    HADOLINT_SHA256_AMD64 = "6bf226944684f56c84dd014e8b979d27425c0148f61b3bd99bcc6f39e9dc5a47"
    HADOLINT_URL_ARM64 = "https://github.com/hadolint/hadolint/releases/download/v2.14.0/hadolint-linux-arm64"
    HADOLINT_SHA256_ARM64 = "331f1d3511b84a4f1e3d18d52fec284723e4019552f4f47b19322a53ce9a40ed"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Dockerfile linter, validate inline bash, written in Haskell." 
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.container-build-publish-action.run-test-stage" = "false"
    "dev.boxcutter.container-build-publish-action.run-lint-stage" = "false"
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

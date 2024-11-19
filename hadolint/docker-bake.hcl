variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/hadolint"
}

variable "VERSION" {
  default = "2.12.0"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    HADOLINT_URL_AMD64 = "https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64"
    HADOLINT_SHA256_AMD64 = "56de6d5e5ec427e17b74fa48d51271c7fc0d61244bf5c90e828aab8362d55010"
    HADOLINT_URL_ARM64 = "https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-arm64"
    HADOLINT_SHA256_ARM64 = "5798551bf19f33951881f15eb238f90aef023f11e7ec7e9f4c37961cb87c5df6"
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

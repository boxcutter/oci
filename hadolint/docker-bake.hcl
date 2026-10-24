variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/hadolint"
}

variable "VERSION" {
  default = "2.15.1"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    HADOLINT_URL_AMD64 = "https://github.com/hadolint/hadolint/releases/download/v2.15.1/hadolint-linux-x86_64"
    HADOLINT_SHA256_AMD64 = "c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507"
    HADOLINT_URL_ARM64 = "https://github.com/hadolint/hadolint/releases/download/v2.15.1/hadolint-linux-arm64"
    HADOLINT_SHA256_ARM64 = "f6198ef8090f404dbb771abfee086eb8c48ac177f30da7fd3510aca35b344b5d"
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

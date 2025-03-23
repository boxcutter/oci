variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/buildpack-deps"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

variable "VARIANT" {
  default = [
    { name = "curl", tag = "-curl" },
    { name = "scm", tag = "-scm" },
    { name = "buildpack-deps", tag = "" },
  ]
}

variable "BUILDTAGS" {
  default = [
    { name = "jammy", base = "docker.io/ubuntu:jammy-20250126", version = "22.04" },
  ]
}

target "_common" {
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "A collection of common build dependencies used for installing various modules."
    "org.opencontainers.image.title" = "${TAG_PREFIX}"
    "org.opencontainers.image.created" = "${timestamp()}"
    "dev.boxcutter.image.readme-filepath" = "buildpack-deps/README.md"
  }
}

target "local" {
  inherits = ["_common"]
  name = "local-${buildtags.name}-${variant.name}"
  matrix = {
    variant = VARIANT,
    buildtags = BUILDTAGS,
  }
  target = variant.name
  args = {
    BASE_IMAGE = buildtags.base
  }
  tags = [
    "${TAG_PREFIX}:${buildtags.name}${variant.tag}",
    "${TAG_PREFIX}:${buildtags.version}${variant.tag}"
  ]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  inherits = ["_common"]
  name = "default-${buildtags.name}-${variant.name}"
  matrix = {
    variant = VARIANT,
    buildtags = BUILDTAGS,
  }
  target = variant.name
  args = {
    BASE_IMAGE = buildtags.base
  }
  tags = [
    "${TAG_PREFIX}:${buildtags.name}${variant.tag}",
    "${TAG_PREFIX}:${buildtags.version}${variant.tag}"
  ]
  platforms = ["linux/amd64", "linux/arm64/v8"]  
}

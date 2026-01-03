variable "TAG_PREFIX" {
  default  = "docker.io/boxcutter"
}

variable "VERSION" {
  default = "3.214.0"
"}

# Explicitly define the latest nodejs version used for the consolidated image
variable "LATEST_NODEJS" {
  default = "24"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

variable "IMAGES" {
  default = [
    "pulumi-nodejs-20",
    "pulumi-nodejs-22",
    "pulumi-nodejs-24"
  ]
}

target "_common" {
  args = {
    PULUMI_VERSION = "${VERSION}"
  }
  dockerfile = "Containerfile"
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Pulumi CLI container for nodejs."
    "org.opencontainers.image.title" = "${TAG_PREFIX}/pulumi-nodejs"
    "dev.boxcutter.image.readme-filepath" = "pulumi/README.md"
  }
}

target "local-matrix" {
  # replace `.` with `-` for the expanded image_name
  name = "local-${regex_replace("${image_name}", "\\.", "-")}"
  inherits = ["_common"]
  matrix = {
    image_name = IMAGES
  }
  platforms = ["${LOCAL_PLATFORM}"]
  tags = [
    "${TAG_PREFIX}/${image_name}:${VERSION}",
    "${TAG_PREFIX}/${image_name}:${VERSION}-noble",
    "${TAG_PREFIX}/${image_name}:latest"
  ]
  args = {
    LANGUAGE_VERSION = "${regex_replace("${image_name}", "^.*-", "")}"
  }
}

group "local" {
  targets = [
    "local-matrix",          # all expanded matrix targets
    "local-pulumi-nodejs-latest"
  ]
}

target "local-pulumi-nodejs-latest" {
  inherits  = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
  tags = [
    "${TAG_PREFIX}/pulumi-nodejs:${VERSION}",
    "${TAG_PREFIX}/pulumi-nodejs:${VERSION}-noble",
    "${TAG_PREFIX}/pulumi-nodejs:latest",
  ]
  args = {
    LANGUAGE_VERSION = "${LATEST_NODEJS}"
  }
}

target "default-matrix" {
  # replace `.` with `-` for the expanded image_name
  name = "default-${regex_replace("${image_name}", "\\.", "-")}"
  inherits = ["_common"]
  matrix = {
    image_name = IMAGES
  }
  # target = image_name
  platforms = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "${TAG_PREFIX}/${image_name}:${VERSION}",
    "${TAG_PREFIX}/${image_name}:${VERSION}-noble",
    "${TAG_PREFIX}/${image_name}:latest"
  ]
  args = {
    LANGUAGE_VERSION = "${regex_replace("${image_name}", "^.*-", "")}"
  }
}

target "default-pulumi-nodejs-latest" {
  inherits  = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "${TAG_PREFIX}/pulumi-nodejs:${VERSION}",
    "${TAG_PREFIX}/pulumi-nodejs:${VERSION}-noble",
    "${TAG_PREFIX}/pulumi-nodejs:latest",
  ]
  args = {
    LANGUAGE_VERSION = "${LATEST_NODEJS}"
  }
}

group "default" {
  targets = [
    "default-matrix",          # all expanded matrix targets
    "default-pulumi-nodejs-latest"
  ]
}

variable "TAG_PREFIX" {
  default  = "docker.io/boxcutter"
}

variable "VERSION" {
  default = "3.214.0"
}

# Explicitly define the latest Python version used for the consolidated image
variable "LATEST_PYTHON" {
  default = "3.13"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

variable "IMAGES" {
  default = [
    "pulumi-python-3.10",
    "pulumi-python-3.11",
    "pulumi-python-3.12",
    "pulumi-python-3.13",
    "pulumi-python-3.14"
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
    "org.opencontainers.image.description" = "Pulumi CLI container for python."
    "org.opencontainers.image.title" = "${TAG_PREFIX}/pulumi-python"
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
    "local-pulumi-python-latest"
  ]
}

target "local-pulumi-python-latest" {
  inherits  = ["_common"]
  platforms = ["${LOCAL_PLATFORM}"]
  tags = [
    "${TAG_PREFIX}/pulumi-python:${VERSION}",
    "${TAG_PREFIX}/pulumi-python:${VERSION}-noble",
    "${TAG_PREFIX}/pulumi-python:latest",
  ]
  args = {
    LANGUAGE_VERSION = "${LATEST_PYTHON}"
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

target "default-pulumi-python-latest" {
  inherits  = ["_common"]
  platforms = ["linux/amd64", "linux/arm64/v8"]
  tags = [
    "${TAG_PREFIX}/pulumi-python:${VERSION}",
    "${TAG_PREFIX}/pulumi-python:${VERSION}-noble",
    "${TAG_PREFIX}/pulumi-python:latest",
  ]
  args = {
    LANGUAGE_VERSION = "${LATEST_PYTHON}"
  }
}

group "default" {
  targets = [
    "default-matrix",          # all expanded matrix targets
    "default-pulumi-python-latest"
  ]
}

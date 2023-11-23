variable "IMAGE_NAME" {
  default =  "erlang"
}

variable "VERSION" {
  default = "26.1.2.0"
}

variable "CONTAINER_REGISTRY" {
  default = "docker.io/boxcutter"
}

# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}

target "_common" {
  args = {
    OTP_VERSION = "26.1.2"
    OTP_DOWNLOAD_SHA256 = "56042d53b30863d4e720ebf463d777f0502f8c986957fc3a9e63dae870bbafe0"
    REBAR3_VERSION = "3.20.0"
	  REBAR3_DOWNLOAD_SHA256 = "53ed7f294a8b8fb4d7d75988c69194943831c104d39832a1fa30307b1a8593de"
  }
  dockerfile = "Containerfile"
  tags = [
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:${VERSION}",
    "${CONTAINER_REGISTRY}/${IMAGE_NAME}:latest"
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "Erlang is a programming language used to build massively scalable systems with high availability."
    "org.opencontainers.image.title" = "${IMAGE_NAME}"
    "io.boxcutter.image.readme-filepath" = "erlang/README.md"
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
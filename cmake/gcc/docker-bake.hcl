variable "TAG_PREFIX" {
  default = "docker.io/boxcutter/cmake-gcc"
}
  
variable "VERSION" {
  default = "3.30.3"
}
    
# There's no darwin-based Docker, so if we're running on macOS, change the platform to linux
variable "LOCAL_PLATFORM" {
  default = regex_replace("${BAKE_LOCAL_PLATFORM}", "^(darwin)", "linux")
}
  
target "_common" {
  args = {
    CMAKE_URL_AMD64 = "https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-x86_64.tar.gz"
    CMAKE_SHA256_AMD64 = "4a5864e9ff0d7945731fe6d14afb61490bf0ec154527bc3af0456bd8fa90decb"
    CMAKE_URL_ARM64 = "https://github.com/Kitware/CMake/releases/download/v3.30.3/cmake-3.30.3-linux-aarch64.tar.gz"
    CMAKE_SHA256_ARM64 = "420f17c58de4ed8b53c1055a34318aec5c06d94b04dac9dd3c72861dfdc99d52"
  }
  dockerfile = "Containerfile"
  tags = [
    "${TAG_PREFIX}:${VERSION}",
    "${TAG_PREFIX}:latest",
  ]
  labels = {
    "org.opencontainers.image.source" = "https://github.com/boxcutter/oci"
    "org.opencontainers.image.licenses" = "Apache-2.0"
    "org.opencontainers.image.description" = "The CMake build tool with the GCC toolchain."
    "org.opencontainers.image.title" = "${TAG_PREFIX}}"
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

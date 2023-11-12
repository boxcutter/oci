variable "LOCAL_PLATFORM" {
  default="${BAKE_LOCAL_PLATFORM}" == "darwin/arm64/v8" ? "linux/arm64/v8" : "${BAKE_LOCAL_PLATFORM}"
}

target "local" {
  dockerfile = "Containerfile"
  tags= [
    "docker.io/boxcutter/fpm:latest"
  ]
  platforms = ["${LOCAL_PLATFORM}"]
}

target "default" {
  dockerfile = "Containerfile"
  tags= [
    "docker.io/boxcutter/fpm:latest"
  ]
  platforms = ["linux/amd64", "linux/arm64/v8"]
} 

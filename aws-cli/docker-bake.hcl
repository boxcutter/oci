target "default" {
  tags = [
    "docker.io/boxcutter/aws-cli:2.13.28",
    "docker.io/boxcutter/aws-cli:latest"
  ]
  dockerfile = "Containerfile"
  platforms = ["linux/amd64", "linux/arm64/v8"]
}

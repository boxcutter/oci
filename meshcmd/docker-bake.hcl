target "default" {
  dockerfile = "Containerfile"
  tags = ["docker.io/boxcutter/meshcmd:1.1.9",
          "docker.io/boxcutter/meshcmd:latest"]
}

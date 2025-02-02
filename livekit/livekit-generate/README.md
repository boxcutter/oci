# livekit-cli

Use the LiveKit configuration generation tool to create a customized
configuration for your domain. The script should be run on your development
machine:

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/output \
  docker.io/boxcutter/livekit-generate
```

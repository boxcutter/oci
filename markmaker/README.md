# markmaker

Packaging Jérôme Petazzoni's tool for creating slide decks with markdown:
https://github.com/jpetazzo/container.training/blob/main/slides/README.md

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slides" \
  docker.io/boxcutter/markmaker /bin/bash
```

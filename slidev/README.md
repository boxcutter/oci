# slidev

Based on https://github.com/tangramor/slidev_docker/blob/master/Dockerfile

# Creating a slideshow project

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --publish 3030:3030 \
  --entrypoint /bin/bash \
  docker.io/boxcutter/slidev \
    -c "echo n | npm init slidev@latest --yes my-project"
```

# Viewing the slideshow

```
cd my-project
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target="/slidev" \
  --publish 3030:3030 \
  docker.io/boxcutter/slidev --remote
# Browse to http://localhost:3030/
```

prometheus
----------
This image repackages Prometheus releases from https://github.com/prometheus/prometheus/releases

The image is based on https://github.com/prometheus/prometheus/blob/main/Dockerfile

Image Source: https://github.com/boxcutter/oci/tree/main/prometheus/prometheus

```
docker container run -it --rm \
-d \
--name prometheus \
--network host \
--mount type=bind,source="$(pwd)/prometheus.yml",target=/etc/prometheus/prometheus.yml,readonly \
--mount type=bind,source="$(pwd)/targets.yml",target=/etc/prometheus/targets.yml,readonly \
--mount type=volume,source=prometheus-data,target=/prometheus,volume-driver=local \
docker.io/boxcutter/prometheus
```
# snmp-generator

```bash
mkdir tmp
git clone https://github.com/prometheus/snmp_exporter.git tmp/snmp_exporter
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/code \
  --entrypoint /bin/bash \
  docker.io/boxcutter/snmp-generator

cd tmp/snmp_exporter/generator
```

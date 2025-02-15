#  cinc

This image packages [Cinc Client](https://cinc.sh/) binaries as a data
container that can be used with [kitchen-dokken](https://github.com/test-kitchen/kitchen-dokken).

A data container is an older pattern used more commonly before named volumes
were supported in Docker. A data container is an image used to pre-populate data
for other containers. Kitchen-dokken uses this data container to avoid needing
to install the chef-client in new Test Kitchen instances and other cookbook
-related data. The `--volumes-from` parameter is used to load the volumes
mounted in the data container when a Test Kitchen test instance  is run. A data
container is used instead of a named volume because Test Kitchen uses a mix
of bind mounts and volumes mounts to share data, so a container is needed.

Modify your `kitchen.yml` similar to the following in order to use cinc instead
of chef in Test Kitchen:

```
---
driver:
  name: dokken
  privileged: true  # allows systemd services to start
  docker_registry: docker.io
  chef_image: boxcutter/cinc
  chef_version: 18.4.12

provisioner:
  name: dokken
  product_name: cinc
  chef_binary: /opt/cinc/bin/cinc-client
  chef_license: accept-no-persist
```

This image packages releases from http://downloads.cinc.sh/files/stable/cinc/

This image is based on source from: https://gitlab.com/cinc-project/upstream/chef/-/blob/stable/cinc/Dockerfile

Source for this image: https://github.com/boxcutter/oci/tree/main/cinc/cinc


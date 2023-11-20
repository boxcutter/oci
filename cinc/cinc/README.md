# cinc

This image packages [Cinc Client](https://cinc.sh/) releases so that
cinc can be used with [kitchen-dokken](https://github.com/test-kitchen/kitchen-dokken)
instead of the default chef-client.

Modify your `kitchen.yml` similar to the following in order to use cinc instead
of chef in Test Kitchen:

```
---
driver:
  name: dokken
  privileged: true  # allows systemd services to start
  docker_registry: docker.io
  chef_image: boxcutter/cinc
  chef_version: 18.2.7

provisioner:
  name: dokken
  product_name: cinc
  chef_binary: /opt/cinc/bin/cinc-client
  chef_license: accept-no-persist
```

This image packages releases from http://downloads.cinc.sh/files/stable/cinc/

This image is based on source from: https://gitlab.com/cinc-project/upstream/chef/-/blob/stable/cinc/Dockerfile

Source for this image: https://github.com/boxcutter/oci/tree/main/cinc/cinc


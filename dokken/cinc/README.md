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

## More information on the data container pattern

The data centainer pattern is a clever way to install the chef client as
a "sidecar install" where it is a companion container that runs alongside
a primary container. This allows different versions of the Chef client to
be used without needing them to be installed each Dokken OS image, speeding
up converage time. One of the tricks kitchen-dokken uses to be so fast.

A data container is just a regular container that holds data volumes but does
not run a long-lived process. The container just holds a binary install of
the Chef client that other containers can mount into their overlay filesystems.
Behind the scenes the kitchen-dokken plugin is using the docker API to create,
but NOT start a process in the data container, similar as if it ran the
following docker command:

```
docker create  \
  --mount type=volume,source=chef-18.6.2,destination=/opt/cinc \
  --name chef-18.6.2 \
  docker.io/boxcutter/cinc:18.6.2
```

Then any other container can be launched that mounts the volume from
the data container using `--volumes-from`. They will see the Chef client
binaries in the `/opt/cinc` directory, as if it had been installed:

```
docker run -it --rm \
  --volumes-from chef-18.6.2 \
  docker.io/ubuntu bash
```

OK, that's all well and good, but if you look at the Dockerfile for this
container more closely, you may notice that it only installs the RedHat
version of the Chef Client. And further, you might be aware that the
RedHat package dynamically links all the libraries and references used
at runtime - so how can this work on Ubuntu or anything else really?
Plus if you know anything about how Test Kitchen works, doesn't Train library
that Test Kitcchen uses require SSH for transport?

The kitchen-dokken plugin also creates a "data image" on demand with
`docker build` that has `ssh` installed along with a few other packages
needed for the Train transport to communicate from Test Kitchen running
on your host to your test Docker instance. It just happens to be a
RedHat-based image - why the RedHat version of Chef client is used. It also
has all the required dynamic library dependencies. The dynamic build of
this image and spinning this up is what takes most of the time for the first
`kitchen converge` to happen - why it takes as long as it does. Here's
an abbreviated version of what that [Dockerfile looks like](https://github.com/test-kitchen/kitchen-dokken/blob/main/lib/kitchen/helpers.rb#L60C1-L89C8)

```
FROM docker.io/almalinux:9

# Install dependencies needed for the Train transport used in Test Kitchen
RUN dnf -y install tar rsync openssh-server passwd git

# Stuff for dealing with generating ssh-key and registering omitted.

# Run the openssh server in the container,  so that Test Kitchen on the host
# can access the container via SSH (also since this is the main process for
# the container, it prevents the container from existing immediately).
CMD [ "/usr/sbin/sshd", "-D", "-p", "22", "-o", "UseDNS=no", "-o", "UsePrivilegeSeparation=no", "-o", "MaxAuthTries=60" ]

# Define persistent volumes to store Kitchen test data and InSpec test results
# Volumes ensure the test files persist across multiple runs and speed up
# repeated test executions.
VOLUME /opt/kitchen
VOLUME /opt/verifier
```

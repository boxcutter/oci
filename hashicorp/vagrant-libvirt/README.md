# vagrant-libvirt

This image includes Hashicorp Vagrant with the Libvirt provider for Vagrant
preinstalled installed. This is the easiest way to use vagrant with libvirt,
as you'll likely encounter many issues with compatibility between the ruby
runtime environment that is part of the upstream vagrant installation and
the dependencies required for libvirt, as pointed out in
https://vagrant-libvirt.github.io/vagrant-libvirt/installation#requirements

This image includes recent versions of Vagrant.

This image packages releases from https://github.com/vagrant-libvirt/vagrant-libvirt

To run this image:

```
# Make sure ~/.vagrant.d exists before running
mkdir -p ~/.vagrant.d

docker run --interactive --tty --rm \
  --env LIBVIRT_DEFAULT_URI \
  --mount type=bind,source=/var/run/libvirt/,target=/var/run/libvirt/ \
  --mount type=bind,source=$HOME/.vagrant.d,target=/.vagrant.d \
  --mount type=bind,source="${PWD}",target=${PWD} \
  --workdir "${PWD}" \
  --network host \
  docker.io/boxcutter/vagrant-libvirt \
    vagrant status
```

Then you can define a function in your `./bashrc` to alias this long docker
command to a `vagrant` alias:

```
vagrant(){
  docker run --interactive --tty --rm \
    --env LIBVIRT_DEFAULT_URI \
    --mount type=bind,source=/var/run/libvirt/,target=/var/run/libvirt/ \
    --mount type=bind,source=$HOME/.vagrant.d,target=/.vagrant.d \
    --mount type=bind,source="${PWD}",target=${PWD} \
    --workdir "${PWD}" \
    --network host \
    docker.io/boxcutter/vagrant-libvirt \
      vagrant $@
}
```

This you should be able to spin up an example box:

```bash
mkdir box
cd box
vagrant init generic/ubuntu2204
export VAGRANT_DEFAULT_PROVIDER=libvirt
vagrant up --provider=libvirt
vagrant ssh
vagrant destroy
``

# ubuntu-autoinstall

This image can be used to generate Ubuntu autoinstall ISOs. It is based
on [cloudymax/pxeless](https://github.com/cloudymax/pxeless) which is in
turn based on [covertsh/ubuntu-autoinstall-generator](https://github.com/covertsh/ubuntu-autoinstall-generator).

```
% docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/ubuntu-autoinstall
```

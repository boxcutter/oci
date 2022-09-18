# bootstrap

The images in this subdirectory are needed to bootstrap the build system. The scripts in the `/bin` directory reference these images:
- cinc-auditor
- dasel
- hadolint

If you happen to want to transplant this repo to your local environment and customize it for your purposes, just make sure you bootstrap the system by making sure these images are at least published locally. The scripts in `/bin` will also print out helpful error messages when they can't find the required prerequisite container images.

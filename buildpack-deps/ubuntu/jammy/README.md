# buildpack-deps

In spirit, `buildpack-deps` is similar to Heroku's stack images. It includes a large number of "development header" packages needed by various things like Ruby Gems, PyPI modules, etc. For example, `buildpack-deps` would let you do a `bundle install` in an arbitrary application directory without knowing beforehand that ssl.h is required to build a dependent module.

## Usage Notes

Primary used as a base image:

```
FROM docker.io/boxcutter/buildpack-deps:[version]
```
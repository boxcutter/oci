#  hadolint

Hadolint is a linter for Containerfiles/Dockerfiles. It helps you build [best practice](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/) container images. 

We use this during the `lint` phase of our CI pipelines for container images.

This image packages releases from https://github.com/hadolint/hadolint

Image source: https://github.com/boxcutter/oci/tree/main/bootstrap/hadolint

# Using hadolint

To lint a `Containerfile` just pipe it to `docker run`:

```bash
docker container run --rm -i docker.io/boxcutter/hadolint < Containerfile
```

# CLI

```bash
docker container run --rm -i docker.io/boxcutter/hadolint hadolint --help
hadolint - Dockerfile Linter written in Haskell

Usage: hadolint [-v|--version] [-c|--config FILENAME] [DOCKERFILE...]
                [--file-path-in-report FILEPATHINREPORT] [--no-fail]
                [--no-color] [-V|--verbose] [-f|--format ARG] [--error RULECODE]
                [--warning RULECODE] [--info RULECODE] [--style RULECODE]
                [--ignore RULECODE]
                [--trusted-registry REGISTRY (e.g. docker.io)]
                [--require-label LABELSCHEMA (e.g. maintainer:text)]
                [--strict-labels] [--disable-ignore-pragma]
                [-t|--failure-threshold THRESHOLD]

  Lint Dockerfile for errors and best practices

Available options:
  -h,--help                Show this help text
  -v,--version             Show version
  -c,--config FILENAME     Path to the configuration file
  --file-path-in-report FILEPATHINREPORT
                           The file path referenced in the generated report.
                           This only applies for the 'checkstyle' format and is
                           useful when running Hadolint with Docker to set the
                           correct file path.
  --no-fail                Don't exit with a failure status code when any rule
                           is violated
  --no-color               Don't colorize output
  -V,--verbose             Enables verbose logging of hadolint's output to
                           stderr
  -f,--format ARG          The output format for the results [tty | json |
                           checkstyle | codeclimate | gitlab_codeclimate | gnu |
                           codacy | sonarqube | sarif] (default: tty)
  --error RULECODE         Make the rule `RULECODE` have the level `error`
  --warning RULECODE       Make the rule `RULECODE` have the level `warning`
  --info RULECODE          Make the rule `RULECODE` have the level `info`
  --style RULECODE         Make the rule `RULECODE` have the level `style`
  --ignore RULECODE        A rule to ignore. If present, the ignore list in the
                           config file is ignored
  --trusted-registry REGISTRY (e.g. docker.io)
                           A docker registry to allow to appear in FROM
                           instructions
  --require-label LABELSCHEMA (e.g. maintainer:text)
  The option --require-label=label:format makes
  Hadolint check that the label `label` conforms to
  format requirement `format`
  --strict-labels          Do not permit labels other than specified in
  `label-schema`
  --disable-ignore-pragma  Disable inline ignore pragmas `# hadolint
  ignore=DLxxxx`
  -t,--failure-threshold THRESHOLD
  Exit with failure code only when rules with a
  severity equal to or above THRESHOLD are violated.
  Accepted values: [error | warning | info | style |
  ignore | none] (default: info)
```

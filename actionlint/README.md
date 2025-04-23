# actionlint

actionlint is a static checker for GitHub Actions workflow files.

This image packages releases from https://github.com/rhysd/actionlint

Image source: https://github.com/boxcutter/oci/tree/main/actionlint

To check all workflows in your repository, mount your repository's root directory as a volume and run actionlint in the mounted directory. When you are at a root directory of your repository:

```bash
docker container run -i --rm \
  --mount type=bind,source="$(pwd)",target=/repo \
  docker.io/boxcutter/actionlint -color
```

To check a file with actionlint, pass the file content via stdin and use - argument:

```bash
cat /path/to/workflow.yml | docker container run -i --rm \
  docker.io/boxcutter/actionlint -color -
```

Or mount the workflows directory and pass the paths as arguments:

```bash
docker container run -i --rm \
  --mount type=bind,source=/path/to/workflows,target=//workflows \
  docker.io/boxcutter/actionlint -color /workflows/ci.yml
```


# CLI

```bash
docker container run --rm -i \
  docker.io/boxcutter/actionlint -h
Usage: actionlint [FLAGS] [FILES...] [-]

  actionlint is a linter for GitHub Actions workflow files.

  To check all YAML files in current repository, just run actionlint without
  arguments. It automatically finds the nearest '.github/workflows' directory:

    $ actionlint

  To check specific files, pass the file paths as arguments:

    $ actionlint file1.yaml file2.yaml

  To check content which is not saved in file yet (e.g. output from some
  command), pass - argument. It reads stdin and checks it as workflow file:

    $ actionlint -

  To serialize errors into JSON, use -format option. It allows to format error
  messages flexibly with Go template syntax.

    $ actionlint -format '{{json .}}'

Documents:

  - List of checks: https://github.com/rhysd/actionlint/tree/v1.7.7/docs/checks.md
  - Usage:          https://github.com/rhysd/actionlint/tree/v1.7.7/docs/usage.md
  - Configuration:  https://github.com/rhysd/actionlint/tree/v1.7.7/docs/config.md

Flags:
  -color
      Always enable colorful output. This is useful to force colorful outputs
  -config-file string
      File path to config file
  -debug
      Enable debug output (for development)
  -format string
      Custom template to format error messages in Go template syntax. See the usage documentation for more details
  -ignore value
      Regular expression matching to error messages you want to ignore. This flag is repeatable
  -init-config
      Generate default config file at .github/actionlint.yaml in current project
  -no-color
      Disable colorful output
  -oneline
      Use one line per one error. Useful for reading error messages from programs
  -pyflakes string
      Command name or file path of "pyflakes" external command. If empty, pyflakes integration will be disabled (default "pyflakes")
  -shellcheck string
      Command name or file path of "shellcheck" external command. If empty, shellcheck integration will be disabled (default "shellcheck")
  -stdin-filename string
      File name when reading input from stdin (default "<stdin>")
  -verbose
      Enable verbose output
  -version
      Show version and how this binary was installed  
```
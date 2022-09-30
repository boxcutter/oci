# black

Black is the uncompromising Python code formatter.

---

**[Read the documentation on ReadTheDocs!](https://black.readthedocs.io/en/stable)**

---

This image packages flake8 releases from PyPI: https://github.com/psf/black

Image source: https://github.com/boxcutter/oci/tree/main/black

# Using black

You can try out Black in the [Black Playground](https://black.vercel.app/).

By default, the container image will run `black` in the `/code` directory:

```shell
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/code \
  docker.io/boxcutter/black .
```

# CLI

```black
% docker container run -it --rm docker.io/boxcutter/black --help
Usage: black [OPTIONS] SRC ...

  The uncompromising code formatter.

Options:
  -c, --code TEXT                 Format the code passed in as a string.
  -l, --line-length INTEGER       How many characters per line to allow.
                                  [default: 88]
  -t, --target-version [py33|py34|py35|py36|py37|py38|py39|py310]
                                  Python versions that should be supported by
                                  Black's output. [default: per-file auto-
                                  detection]
  --pyi                           Format all input files like typing stubs
                                  regardless of file extension (useful when
                                  piping source on standard input).
  --ipynb                         Format all input files like Jupyter
                                  Notebooks regardless of file extension
                                  (useful when piping source on standard
                                  input).
  --python-cell-magics TEXT       When processing Jupyter Notebooks, add the
                                  given magic to the list of known python-
                                  magics (capture, prun, python3, timeit,
                                  pypy, time, python). Useful for formatting
                                  cells with custom python magics.
  -S, --skip-string-normalization
                                  Don't normalize string quotes or prefixes.
  -C, --skip-magic-trailing-comma
                                  Don't use trailing commas as a reason to
                                  split lines.
  --preview                       Enable potentially disruptive style changes
                                  that may be added to Black's main
                                  functionality in the next major release.
  --check                         Don't write the files back, just return the
                                  status. Return code 0 means nothing would
                                  change. Return code 1 means some files would
                                  be reformatted. Return code 123 means there
                                  was an internal error.
  --diff                          Don't write the files back, just output a
                                  diff for each file on stdout.
  --color / --no-color            Show colored diff. Only applies when
                                  `--diff` is given.
  --fast / --safe                 If --fast given, skip temporary sanity
                                  checks. [default: --safe]
  --required-version TEXT         Require a specific version of Black to be
                                  running (useful for unifying results across
                                  many environments e.g. with a pyproject.toml
                                  file). It can be either a major version
                                  number or an exact version.
  --include TEXT                  A regular expression that matches files and
                                  directories that should be included on
                                  recursive searches. An empty value means all
                                  files are included regardless of the name.
                                  Use forward slashes for directories on all
                                  platforms (Windows, too). Exclusions are
                                  calculated first, inclusions later.
                                  [default: (\.pyi?|\.ipynb)$]
  --exclude TEXT                  A regular expression that matches files and
                                  directories that should be excluded on
                                  recursive searches. An empty value means no
                                  paths are excluded. Use forward slashes for
                                  directories on all platforms (Windows, too).
                                  Exclusions are calculated first, inclusions
                                  later. [default: /(\.direnv|\.eggs|\.git|\.h
                                  g|\.mypy_cache|\.nox|\.tox|\.venv|venv|\.svn
                                  |_build|buck-
                                  out|build|dist|__pypackages__)/]
  --extend-exclude TEXT           Like --exclude, but adds additional files
                                  and directories on top of the excluded ones.
                                  (Useful if you simply want to add to the
                                  default)
  --force-exclude TEXT            Like --exclude, but files and directories
                                  matching this regex will be excluded even
                                  when they are passed explicitly as
                                  arguments.
  --stdin-filename TEXT           The name of the file when passing it through
                                  stdin. Useful to make sure Black will
                                  respect --force-exclude option on some
                                  editors that rely on using stdin.
  -W, --workers INTEGER RANGE     Number of parallel workers  [default: 4;
                                  x>=1]
  -q, --quiet                     Don't emit non-error messages to stderr.
                                  Errors are still emitted; silence those with
                                  2>/dev/null.
  -v, --verbose                   Also emit messages to stderr about files
                                  that were not changed or were ignored due to
                                  exclusion patterns.
  --version                       Show the version and exit.
  --config FILE                   Read configuration from FILE path.
  -h, --help                      Show this message and exit.
```

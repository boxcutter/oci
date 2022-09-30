# flake8

Flake8 is a wrapper around these tools:

- PyFlakes
- pycodestyle
- Ned Batchelder’s McCabe script

Flake8 runs all the tools by launching the single flake8 command. It displays the warnings in a per-file, merged output.

This image packages flake8 releases from PyPI: https://github.com/PyCQA/flake8

Image source: https://github.com/boxcutter/oci/tree/main/dasel

# Using flake8

By default, the container image will run `flake8` in the `/code` directory:

```bash
docker container run -it --rm \
  --mount type=bin,source="$(pwd)",target=/code \
  docker.io/boxcutter/flake8
```

Pass any desired arguments after flake8


```bash
docker container run -it --rm \
  --mount type=bin,source="$(pwd)",target=/code \
  docker.io/boxcutter/flake8 --max-complexity 12 coolproject
```

# CLI

```
% docker container run -it --rm docker.io/boxcutter/flake8 --help
usage: flake8 [options] file file ...

positional arguments:
  filename

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         Print more information about what is happening in
                        flake8. This option is repeatable and will increase
                        verbosity each time it is repeated.
  --output-file OUTPUT_FILE
                        Redirect report to a file.
  --append-config APPEND_CONFIG
                        Provide extra config files to parse in addition to the
                        files found by Flake8 by default. These files are the
                        last ones read and so they take the highest precedence
                        when multiple files provide the same option.
  --config CONFIG       Path to the config file that will be the authoritative
                        config source. This will cause Flake8 to ignore all
                        other configuration files.
  --isolated            Ignore all configuration files.
  --enable-extensions ENABLE_EXTENSIONS
                        Enable plugins and extensions that are otherwise
                        disabled by default
  --require-plugins REQUIRE_PLUGINS
                        Require specific plugins to be installed before
                        running
  --version             show program's version number and exit
  -q, --quiet           Report only file names, or nothing. This option is
                        repeatable.
  --color {auto,always,never}
                        Whether to use color in output. Defaults to `auto`.
  --count               Print total number of errors to standard output and
                        set the exit code to 1 if total is not empty.
  --diff                (DEPRECATED) Report changes only within line number
                        ranges in the unified diff provided on standard in by
                        the user.
  --exclude patterns    Comma-separated list of files or directories to
                        exclude. (Default: ['.svn', 'CVS', '.bzr', '.hg',
                        '.git', '__pycache__', '.tox', '.nox', '.eggs',
                        '*.egg'])
  --extend-exclude patterns
                        Comma-separated list of files or directories to add to
                        the list of excluded ones.
  --filename patterns   Only check for filenames matching the patterns in this
                        comma-separated list. (Default: ['*.py'])
  --stdin-display-name STDIN_DISPLAY_NAME
                        The name used when reporting errors from code passed
                        via stdin. This is useful for editors piping the file
                        contents to flake8. (Default: stdin)
  --format format       Format errors according to the chosen formatter.
  --hang-closing        Hang closing bracket instead of matching indentation
                        of opening bracket's line.
  --ignore errors       Comma-separated list of error codes to ignore (or
                        skip). For example, ``--ignore=E4,E51,W234``.
                        (Default: E121,E123,E126,E226,E24,E704,W503,W504)
  --extend-ignore errors
                        Comma-separated list of error codes to add to the list
                        of ignored ones. For example, ``--extend-
                        ignore=E4,E51,W234``.
  --per-file-ignores PER_FILE_IGNORES
                        A pairing of filenames and violation codes that
                        defines which violations to ignore in a particular
                        file. The filenames can be specified in a manner
                        similar to the ``--exclude`` option and the violations
                        work similarly to the ``--ignore`` and ``--select``
                        options.
  --max-line-length n   Maximum allowed line length for the entirety of this
                        run. (Default: 79)
  --max-doc-length n    Maximum allowed doc line length for the entirety of
                        this run. (Default: None)
  --indent-size n       Number of spaces used for indentation (Default: 4)
  --select errors       Comma-separated list of error codes to enable. For
                        example, ``--select=E4,E51,W234``. (Default:
                        E,F,W,C90)
  --extend-select errors
                        Comma-separated list of error codes to add to the list
                        of selected ones. For example, ``--extend-
                        select=E4,E51,W234``.
  --disable-noqa        Disable the effect of "# noqa". This will report
                        errors on lines with "# noqa" at the end.
  --show-source         Show the source generate each error or warning.
  --no-show-source      Negate --show-source
  --statistics          Count errors.
  --exit-zero           Exit with status code "0" even if there are errors.
  -j JOBS, --jobs JOBS  Number of subprocesses to use to run checks in
                        parallel. This is ignored on Windows. The default,
                        "auto", will auto-detect the number of processors
                        available to use. (Default: auto)
  --tee                 Write to stdout and output-file.
  --benchmark           Print benchmark information about this run of Flake8
  --bug-report          Print information necessary when preparing a bug
                        report

mccabe:
  --max-complexity MAX_COMPLEXITY
                        McCabe complexity threshold

pyflakes:
  --builtins BUILTINS   define more built-ins, comma separated
  --doctests            also check syntax of the doctests
  --include-in-doctest INCLUDE_IN_DOCTEST
                        Run doctests only on these files
  --exclude-from-doctest EXCLUDE_FROM_DOCTEST
                        Skip these files when running doctests

Installed plugins: mccabe: 0.7.0, pycodestyle: 2.9.1, pyflakes: 2.5.0
```

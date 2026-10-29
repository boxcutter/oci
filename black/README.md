# black

Black is the uncompromising Python code formatter.

---

**[Read the documentation on ReadTheDocs!](https://black.readthedocs.io/en/stable)**

---

This image packages black releases from PyPI: https://github.com/psf/black

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

```
% docker container run -it --rm docker.io/boxcutter/black --help
Usage: black [OPTIONS] SRC ...

  The uncompromising code formatter.

Options:
  -c, --code TEXT                 Format the code passed in as a string.
  -l, --line-length INTEGER       How many characters per line to allow.
                                  [default: 88]
  -t, --target-version [py33|py34|py35|py36|py37|py38|py39|py310|py311|py312|py313|py314|py315]
                                  Python versions that should be supported by
                                  Black's output. You should include all
                                  versions that your code supports. By
                                  default, Black will infer target versions
                                  from the project metadata in pyproject.toml.
                                  If this does not yield conclusive results,
                                  Black will use per-file auto-detection.
  --pyi                           Format all input files like typing stubs
                                  regardless of file extension. This is useful
                                  when piping source on standard input.
  --ipynb                         Format all input files like Jupyter
                                  Notebooks regardless of file extension. This
                                  is useful when piping source on standard
                                  input.
  --python-cell-magics TEXT       When processing Jupyter Notebooks, add the
                                  given magic to the list of known python-
                                  magics (capture, prun, pypy, python,
                                  python3, time, timeit). Useful for
                                  formatting cells with custom python magics.
  -x, --skip-source-first-line    Skip the first line of the source code.
  -S, --skip-string-normalization
                                  Don't normalize string quotes or prefixes.
  -C, --skip-magic-trailing-comma
                                  Don't use trailing commas as a reason to
                                  split lines.
  --preview                       Enable potentially disruptive style changes
                                  that may be added to Black's main
                                  functionality in the next major release.
  --unstable                      Enable potentially disruptive style changes
                                  that have known bugs or are not currently
                                  expected to make it into the stable style
                                  Black's next major release. Implies
                                  --preview.
  --enable-unstable-feature [string_processing|hug_parens_with_braces_and_square_brackets|wrap_comprehension_in|simplify_power_operator_hugging|wrap_long_dict_values_in_parens|fix_if_guard_explosion_in_case_statement|pyi_overload_group_blank_lines|fix_unnecessary_parens_in_indexed_assignment|pyi_blank_line_before_decorated_class|pyi_blank_line_after_function_docstring|hug_comparator|parenthesize_tuple_in_yield|fmt_off_class_blank_lines|remove_redundant_generator_parentheses|normalize_tstring_prefix|remove_redundant_unpacking_parentheses|fix_magic_trailing_comma_trailer_split|keep_dict_keys_with_operators|blank_line_after_stub_method|keep_commented_expressions_together|avoid_parens_for_unbreakable_rhs_in_assignments|parenthesize_expressions_with_comments|keep_trailers_on_bracket_comment_overflow]
                                  Enable specific features included in the
                                  `--unstable` style. Requires `--preview`. No
                                  compatibility guarantees are provided on the
                                  behavior or existence of any unstable
                                  features.
  --check                         Don't write the files back, just return the
                                  status. Return code 0 means nothing would
                                  change. Return code 1 means some files would
                                  be reformatted. Return code 123 means there
                                  was an internal error.
  --diff                          Don't write the files back, just output a
                                  diff to indicate what changes Black would've
                                  made. They are printed to stdout so
                                  capturing them is simple.
  --color / --no-color            Show (or do not show) colored diff. Only
                                  applies when --diff is given.
  --line-ranges START-END         When specified, Black will try its best to
                                  only format these lines. This option can be
                                  specified multiple times, and a union of the
                                  lines will be formatted. Each range must be
                                  specified as two integers connected by a
                                  `-`: `<START>-<END>`. The `<START>` and
                                  `<END>` integer indices are 1-based and
                                  inclusive on both ends.
  --fast / --safe                 By default, Black performs an AST safety
                                  check after formatting your code. The --fast
                                  flag turns off this check and the --safe
                                  flag explicitly enables it. [default:
                                  --safe]
  --required-version TEXT         Require a specific version of Black to be
                                  running. This is useful for ensuring that
                                  all contributors to your project are using
                                  the same version, because different versions
                                  of Black may format code a little
                                  differently. This option can be set in a
                                  configuration file for consistent results
                                  across environments.
  --exclude TEXT                  A regular expression that matches files and
                                  directories that should be excluded on
                                  recursive searches. An empty value means no
                                  paths are excluded. Use forward slashes for
                                  directories on all platforms (Windows, too).
                                  By default, Black also ignores all paths
                                  listed in .gitignore. Changing this value
                                  will override all default exclusions.
                                  [default: /(\.direnv|\.eggs|\.git|\.hg|\.ipy
                                  nb_checkpoints|\.mypy_cache|\.nox|\.pytest_c
                                  ache|\.ruff_cache|\.tox|\.svn|\.venv|\.vscod
                                  e|__pypackages__|_build|buck-
                                  out|build|dist|venv)/]
  --extend-exclude TEXT           Like --exclude, but adds additional files
                                  and directories on top of the default values
                                  instead of overriding them.
  --force-exclude TEXT            Like --exclude, but files and directories
                                  matching this regex will be excluded even
                                  when they are passed explicitly as
                                  arguments. This is useful when invoking
                                  Black programmatically on changed files,
                                  such as in a pre-commit hook or editor
                                  plugin.
  --stdin-filename TEXT           The name of the file when passing it through
                                  stdin. Useful to make sure Black will
                                  respect the --force-exclude option on some
                                  editors that rely on using stdin.
  --include TEXT                  A regular expression that matches files and
                                  directories that should be included on
                                  recursive searches. An empty value means all
                                  files are included regardless of the name.
                                  Use forward slashes for directories on all
                                  platforms (Windows, too). Overrides all
                                  exclusions, including from .gitignore and
                                  command line options.  [default:
                                  (\.pyi?|\.ipynb)$]
  -W, --workers INTEGER RANGE     When Black formats multiple files, it may
                                  use a process pool to speed up formatting.
                                  This option controls the number of parallel
                                  workers. This can also be specified via the
                                  BLACK_NUM_WORKERS environment variable.
                                  Defaults to the number of CPUs in the
                                  system.  [x>=1]
  -q, --quiet                     Stop emitting all non-critical output. Error
                                  messages will still be emitted (which can
                                  silenced by 2>/dev/null).
  -v, --verbose                   Emit messages about files that were not
                                  changed or were ignored due to exclusion
                                  patterns. If Black is using a configuration
                                  file, a message detailing which one it is
                                  using will be emitted.
  --version                       Show the version and exit.
  --config FILE                   Read configuration options from a
                                  configuration file.
  --cache-dir DIRECTORY           Store the cache in this directory. Takes
                                  precedence over BLACK_CACHE_DIR.
  --no-cache                      Skip reading and writing the cache, forcing
                                  Black to reformat all included files.
                                  Overrides --cache-dir.
  -h, --help                      Show this message and exit.
```

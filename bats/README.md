# bats

Bash Automated Testing System.

This image packages source code releases from:
- https://github.com/bats-core/bats-core
- https://github.com/bats-core/bats-assert
- https://github.com/bats-core/bats-support

The official `bats/bats` container image doesn't include any of the supporting
libraries, so this image addresses this issue.

Also the official container image requires use of the `!/usr/bin/env bash`
shebang because it includes the official bash container image. The official
image installs bash in `/usr/local/bin` and test scripts cannot use a 
hardcoded path to `/bin/bash` in the shebang.  This image makes sure that
bash is installed in `/bin/bash`.

# Using bats

You'll need to bind mount your scripts inside the image when you run it,
so that bats can see your scripts. Bats accepts script paths as
parameters.

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/code,readonly \
  docker.io/boxcutter/bats test/test.bats
```

Bats will also accept a path as a parameter, if you want to run all bats
scripts in a directory.

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/code,readonly \
  docker.io/boxcutter/bats test/
```

The `tutorial/` directory has a more complete example of a test suite
from the bats tutorial at https://bats-core.readthedocs.io/en/stable/tutorial.html
The `./run.sh` script runs BATS from this container image.

# CLI

```
% docker container run --rm -i docker.io/boxcutter/bats -h
Bats 1.8.0
Usage: bats [OPTIONS] <tests>
       bats [-h | -v]

  <tests> is the path to a Bats test file, or the path to a directory
  containing Bats test files (ending with ".bats")

  -c, --count               Count test cases without running any tests
  --code-quote-style <style>
                            A two character string of code quote delimiters
                            or 'custom' which requires setting $BATS_BEGIN_CODE_QUOTE and
                            $BATS_END_CODE_QUOTE. Can also be set via $BATS_CODE_QUOTE_STYLE
  -f, --filter <regex>      Only run tests that match the regular expression
  --filter-status <status>  Only run tests with the given status in the last completed (no CTRL+C/SIGINT) run.
                            Valid <status> values are:
                              failed - runs tests that failed or were not present in the last run
                              missed - runs tests that were not present in the last run
  -F, --formatter <type>    Switch between formatters: pretty (default),
                              tap (default w/o term), tap13, junit, /<absolute path to formatter>
  --gather-test-outputs-in <directory>
                            Gather the output of failing *and* passing tests
                            as files in directory (if existing, must be empty)
  -h, --help                Display this help message
  -j, --jobs <jobs>         Number of parallel jobs (requires GNU parallel)
  --no-tempdir-cleanup      Preserve test output temporary directory
  --no-parallelize-across-files
                            Serialize test file execution instead of running
                            them in parallel (requires --jobs >1)
  --no-parallelize-within-files
                            Serialize test execution within files instead of
                            running them in parallel (requires --jobs >1)
  --report-formatter <type> Switch between reporters (same options as --formatter)
  -o, --output <dir>        Directory to write report files (must exist)
  -p, --pretty              Shorthand for "--formatter pretty"
  --print-output-on-failure Automatically print the value of `$output` on failed tests
  -r, --recursive           Include tests in subdirectories
  --show-output-of-passing-tests
                            Print output of passing tests
  -t, --tap                 Shorthand for "--formatter tap"
  -T, --timing              Add timing information to tests
  -x, --trace               Print test commands as they are executed (like `set -x`)
  --verbose-run             Make `run` print `$output` by default
  -v, --version             Display the version number

  For more information, see https://github.com/bats-core/bats-core
```

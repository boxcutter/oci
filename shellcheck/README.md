# shellcheck

ShellCheck is a linter for bash/sh shell scripts.

This image packages releases from https://github.com/koalaman/shellcheck

# Using shellcheck

Shellcheck has an online playground environment where you can test out example scripts: https://www.shellcheck.net/

Because this is a container image, you need to get the source files into the
image with a bind mount. Other than that, just pass in the name of the script
you want to check as a parameter
 
```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/share,readonly \
  docker.io/boxcutter/shellcheck <myscript>
```

Shellcheck also respects wildcards for filenames, so you can use those in
filename parameters as well:

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/share \
  docker.io/boxcutter/shellcheck ./*.sh
```

# CLI

```
% docker container run --rm docker.io/boxcutter/shellcheck
No files specified.

Usage: shellcheck [OPTIONS...] FILES...
  -a                  --check-sourced            Include warnings from sourced files
  -C[WHEN]            --color[=WHEN]             Use color (auto, always, never)
  -i CODE1,CODE2..    --include=CODE1,CODE2..    Consider only given types of warnings
  -e CODE1,CODE2..    --exclude=CODE1,CODE2..    Exclude types of warnings
  -f FORMAT           --format=FORMAT            Output format (checkstyle, diff, gcc, json, json1, quiet, tty)
                      --list-optional            List checks disabled by default
                      --norc                     Don't look for .shellcheckrc files
  -o check1,check2..  --enable=check1,check2..   List of optional checks to enable (or 'all')
  -P SOURCEPATHS      --source-path=SOURCEPATHS  Specify path when looking for sourced files ("SCRIPTDIR" for script's dir)
  -s SHELLNAME        --shell=SHELLNAME          Specify dialect (sh, bash, dash, ksh)
  -S SEVERITY         --severity=SEVERITY        Minimum severity of errors to consider (error, warning, info, style)
  -V                  --version                  Print version information
  -W NUM              --wiki-link-count=NUM      The number of wiki links to show, when applicable
  -x                  --external-sources         Allow 'source' outside of FILES
                      --help                     Show this usage summary and exit
```

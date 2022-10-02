# markdownlint

A tool to check markdown files and flag style issues.

This image packages markdownlint releases from https://github.com/markdownlint/markdownlint.

Image Source: https://github.com/boxcutter/oci/tree/main/markdownlint

# Using markdown lint

By default, the container image will run markdownlint (mdl) in the /data directory:

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/markdownlint .
```

Markdownlint can also take a directory, and it will scan all markdown files within the directory (and nested directories):

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/markdownlint docs/
```

If you don't specify a filename, markdownlint will use stdin:

```
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/data \
  docker.io/boxcutter/markdownlint < foo.md
```

Markdownlint will output a list of issues it finds, and the line number where the issue is. See [RULES.md](https://github.com/markdownlint/markdownlint/blob/master/docs/RULES.md) for information on each issue, as well as how to correct it.

# CLI

```
% docker run -it --rm docker.io/boxcutter/markdownlint
Usage: mdl [options] [FILE.md|DIR ...]
    -c, --config FILE                The configuration file to use
    -g, --git-recurse                Only process files known to git when given a directory
    -i, --[no-]ignore-front-matter   Ignore YAML front matter
    -j, --json                       JSON output
    -l, --list-rules                 Don't process any files, just list enabled rules
    -r, --rules RULE1,RULE2          Only process these rules
    -u, --rulesets RULESET1,RULESET2 Specify additional ruleset files to load
    -a, --[no-]show-aliases          Show rule alias instead of rule ID when viewing rules
    -w, --[no-]warnings              Show kramdown warnings
    -d, --skip-default-ruleset       Don't load the default markdownlint ruleset
    -s, --style STYLE                Load the given style
    -t, --tags TAG1,TAG2             Only process rules with these tags
    -v, --[no-]verbose               Increase verbosity
    -h, --help                       Show this message
    -V, --version                    Show version
```

# dasel

Dasel (short for data-selector) is a command line processor for JSON, YAML,
TOML, XML and CSV with zero runtime dependencies.

We use this to process the `Polly.toml` files that contain container image
metadata.

This image packages releases from https://github.com/TomWright/dasel

Image source: https://github.com/boxcutter/oci/tree/main/bootstrap/dasel

# Using dasel

Dasel has an online playground environment where you can test out example
queries: https://dasel.tomwright.me/

Dasel also has a comprehensive user guide with command line examples:
https://daseldocs.tomwright.me/

Our primary use case is reading toml files. Basic queries are in the
form of "section.key". The `--null` parameter ensures that a consistent
error result is returned when the key is not found:

```bash
docker container run --rm \
  --mount type=bind,source="$(pwd)",target=/share,readonly \
  docker.io/boxcutter/dasel \
    -f Polly.toml --null "container_image.name"
```

# CLI

```bash
% docker container run -it --rm boxcutter/dasel --help
Select properties from the given file.

Usage:
  dasel select -f <file> -p <json,yaml> -s <selector> [flags]

Flags:
      --color                   Alias of --colour.
      --colour                  Print colourised output.
  -c, --compact                 Compact the output by removing all pretty-printing where possible.
      --escape-html             Escape HTML tags when writing output.
  -f, --file string             The file to query.
      --format string           Formatting template to use when writing results.
  -h, --help                    help for select
      --length                  Output the length of the selected value.
      --merge-input-documents   Merge multiple input documents into an array.
  -m, --multiple                Select multiple results.
  -n, --null                    Output null instead of value not found errors.
  -p, --parser string           Shorthand for -r FORMAT -w FORMAT.
      --plain                   Alias of -w plain
  -r, --read string             The parser to use when reading.
  -s, --selector string         The selector to use when querying the data structure.
  -w, --write string            The parser to use when writing.
```

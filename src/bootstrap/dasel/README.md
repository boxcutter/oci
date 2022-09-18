# dasel

Dasel (short for data-selector) is a command line processor for JSON, YAML,
TOML, XML and CSV with zero runtime dependencies.

We use this to process the `Polly.toml` files that contain container image
metadata.

This image packages releases from https://github.com/TomWright/dasel

# CLI

```
% docker run -it --rm boxcutter/dasel --help
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

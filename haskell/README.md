# haskell

Based on https://github.com/haskell/docker-haskell

The `ghci` REPL can be used to write Haskell code and evaluate it directly.
To exit `ghci`, use the `:quit` command

```
docker run -it --rm \
  docker.io/boxcutter/haskell:9.8-slim-jammy
GHCi, version 9.8.1: https://www.haskell.org/ghc/  :? for help
ghci> 1 + 2 * 3
7
ghci> :quit
Leaving GHCi.
```

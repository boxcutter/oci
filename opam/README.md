# ocaml

The `utop` REPL can be used to evaluate OCaml expressions.
In `utop`, when you enter an expression that ends with `;;` and press enter,
`utop` displays the evaluated value. You can exit `utop` with the
`#quit` command.

```
% docker run -it --rm docker.io/boxcutter/opam
opam@ef8f15fe83ab:~$ utop
────────┬─────────────────────────────────────────────────────────────┬─────────
        │ Welcome to utop version 2.13.1 (using OCaml version 5.1.1)! │
        └─────────────────────────────────────────────────────────────┘

Type #utop_help for help about using utop.

─( 22:58:12 )─< command 0 >──────────────────────────────────────{ counter: 0 }─
utop # 1 + 2;;
- : int = 3
─( 22:58:12 )─< command 1 >──────────────────────────────────────{ counter: 0 }─
utop # #quit;;
```

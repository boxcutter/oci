# texlive

This image packages releases from https://github.com/islandoftex/texlive

# texlive

[TeX Live](https://tug.org/texlive/) is a popular distribution of TeX-related
software. TeX Live is straightforward way to get up and running with the
[TeX document production system](https://tug.org/). It includes all the major
TeX-related programs, macro packages, and fonts that are free software,
including support for many languages around the world.

# Background

In the late 1980's, Donald E. Knuth, the author of TeX, decided to freeze
development of the original TeX software, upon which all the components in
the TeX Live distribution is based on TeX. Out of the box, TeX does not work
with current font technologies, direct PDF output and Unicode, so with Knuth's
blessing, there are now three predominantly used "forks" of TeX called
"TeX engines". Most people do not use Kuth's original version of TeX, except
Knuth himself:
- pdfTeX
- XeTeX
- LuaTeX

Further, in the mid-1980s, Leslie Lamport created a set of TeX macros called
LaTeX. LaTeX is a macro package that added a large collection of high level
commands to control typesetting details. LaTeX is also extensible and there
are a large variety of packages that build on top of the LaTex macro package.
The LaTex macro package has been adapted to each engine, and there are aliases
that signify use of the LaTex macro collection with each engine. This is what
most people commonly use:
- pdflatex
- xelatex
- lualatex

These engines aren't 100% compatible with each other, and it's possible
that a `.tex` file won't render properly or even the same in one engine
vs another. Though these days most documents that compile under pdflatex
will also compile just fine under lualatex or xelatex.

You can find more information on these different engines [here](https://www.overleaf.com/learn/latex/Articles/What%27s_in_a_Name%3A_A_Guide_to_the_Many_Flavours_of_TeX#:~:text=pdfLaTeX%20means%20using%20the%20LaTeX,package%20with%20the%20LuaTeX%20engine). Per this summary, here are some of the key features of these
three most popular TeX engines:

- pdftex/pdflatex: Can output directly to PDF and includes some typesetting
  refinements that produce better output. First released in August 2001.
- xetex/xelatex: Added the ability to work with input TeX files saved in
  UTF-8 encoding and improved multilingual typesetting support. XeTeX
  can also use OpenType fonts. First release in April 2004, initially for
  Mac OSX only.
- luatex/lualatex: The most powerful of all the TeX engines as it adds
  enhanced scripting by incorporating the Lua scripting language. It also
  supports UTF8-8 text encoding and OpenType fonts, though the mechanism
  is slightly different from the ones in XeTeX. It also integrates the
  MetaPost graphics language to add drawing capabilities. Developement
  started around 2006, with a version 1.0 release in September 2016.

No TeX engine can output HTML natively, so there are additional programs
for that:

- htlatex: Uses the PDFTeX engine with LaTeX to produce HTML output
- lwarp: A LaTeX package the directly produces HTML5 output.
- latexml: A Perl program that parses LaTeX documents and generates many 
  different output formats.

## Getting started

To get started, just use `pdflatex` to generate a PDF document or `latex`
to generate a DVI-based device-independent PostScript document. Both of
these commands are just aliases to the `pdftex` executable in the TeX Live
distribution.

```
docker run -it --rm \
  --mount type=bind,source="$(pwd)",target=/doc \
  --workdir /doc \
  docker.io/boxcutter/texlive:latest pdflatex example.tex
```

## Using this image with the Visual Studio Code LaTeX Workshop Extension

### Installation

1. Install [Visual Studio code](https://code.visualstudio.com/).

1. Install and configure Docker for your operating system.

1. In VSCode, Open the Command Palette (Cmd+Shift+P) and run `shell command`
   to install the `code` cli command.

1. On macOS, because of [this issue](https://github.com/microsoft/vscode/issues/141738) if you see this error:
   ```
   /usr/local/bin/code: line 6: python: command not found
   /usr/local/bin/code: line 10: ./MacOS/Electron: No such file or directory
   ```
   Edit `/usr/local/bin/code` and change:
   ```
   # function realpath() { python -c ...
   function realpath() { python3 -c ...
   ```
   This may also require that you give your terminal/editor "App Management"
   permission in "Privacy & Security" to make this change.

1. Install the [Dev Containers extension](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
   ```
   code --install-extension ms-vscode-remote.remote-containers
   ```

1. Install the [LaTex Workshop extension](https://marketplace.visualstudio.com/items?itemName=James-Yu.latex-workshop)
   ```
   code --install-extension James-Yu.latex-workshop
   ```

# CLI

```
% docker run -it --rm \
--mount type=bind,source="$(pwd)",target=/doc \
--workdir /doc \
docker.io/boxcutter/texlive:latest pdflatex --help
Usage: pdftex [OPTION]... [TEXNAME[.tex]] [COMMANDS]
or: pdftex [OPTION]... \FIRST-LINE
or: pdftex [OPTION]... &FMT ARGS
Run pdfTeX on TEXNAME, usually creating TEXNAME.pdf.
Any remaining COMMANDS are processed as pdfTeX input, after TEXNAME is read.
If the first line of TEXNAME is %&FMT, and FMT is an existing .fmt file,
use it.  Else use `NAME.fmt', where NAME is the program invocation name,
most commonly `pdftex'.

Alternatively, if the first non-option argument begins with a backslash,
interpret all non-option arguments as a line of pdfTeX input.

Alternatively, if the first non-option argument begins with a &, the
next word is taken as the FMT to read, overriding all else.  Any
remaining arguments are processed as above.

If no arguments or options are specified, prompt for input.

-cnf-line=STRING        parse STRING as a configuration file line
-draftmode              switch on draft mode (generates no output PDF)
-enc                    enable encTeX extensions such as \mubyte
-etex                   enable e-TeX extensions
[-no]-file-line-error   disable/enable file:line:error style messages
-fmt=FMTNAME            use FMTNAME instead of program name or a %& line
-halt-on-error          stop processing at the first error
-ini                    be pdfinitex, for dumping formats; this is implicitly
true if the program name is `pdfinitex'
-interaction=STRING     set interaction mode (STRING=batchmode/nonstopmode/
scrollmode/errorstopmode)
-ipc                    send DVI output to a socket as well as the usual
output file
-ipc-start              as -ipc, and also start the server at the other end
-jobname=STRING         set the job name to STRING
-kpathsea-debug=NUMBER  set path searching debugging flags according to
the bits of NUMBER
[-no]-mktex=FMT         disable/enable mktexFMT generation (FMT=tex/tfm/pk)
-mltex                  enable MLTeX extensions such as \charsubdef
-output-comment=STRING  use STRING for DVI file comment instead of date
(no effect for PDF)
-output-directory=DIR   use existing DIR as the directory to write files in
-output-format=FORMAT   use FORMAT for job output; FORMAT is `dvi' or `pdf'
[-no]-parse-first-line  disable/enable parsing of first line of input file
-progname=STRING        set program (and fmt) name to STRING
-recorder               enable filename recorder
[-no]-shell-escape      disable/enable \write18{SHELL COMMAND}
-shell-restricted       enable restricted \write18
-src-specials           insert source specials into the DVI file
-src-specials=WHERE     insert source specials in certain places of
the DVI file. WHERE is a comma-separated value
list: cr display hbox math par parend vbox
-synctex=NUMBER         generate SyncTeX data for previewers according to
bits of NUMBER (`man synctex' for details)
-translate-file=TCXNAME use the TCX file TCXNAME
-8bit                   make all characters printable by default
-help                   display this help and exit
-version                output version information and exit

pdfTeX home page: <http://pdftex.org>

Email bug reports to pdftex@tug.org (https://lists.tug.org/pdftex).
```

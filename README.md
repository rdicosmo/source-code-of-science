# The Source Code of Science

A doctoral course note on archiving, referencing and reproducing **research software**, built
on Software Heritage and the SWHID intrinsic identifier (ISO/IEC 18670:2025). It addresses the
FAIR principles and then goes *beyond* them. See `PLAN.md` for the full design and the
chapter-by-chapter sourcing map.

**Status:** scaffold — chapter skeletons with inline sourcing notes; prose to be drafted.

## Structure

```
main.tex            % report class, xelatex, biblatex + software-biblatex
preamble.tex        % fonts, SWH branding, hands-on/takeaway environments, title page
chapters/01..06     % 1 Why · 2 Beyond FAIR · 3 Foundations · 4 ARDC · 5 Reproducibility/AEC · 6 Outlook
appendix/A..C       % cookbook · SWHID syntax · glossary
references.bib      % canonical citekeys + biblatex-software entries (shared with the AEC guide)
figures/ logos/     % reused SWH assets
```

## Build

Requires TeX Live (xelatex, latexmk, biber) and the TeX Gyre fonts.

The bibliography uses the concise `crossrefexpansion` rendering of `biblatex-software`
(≥ `bltx-v1.2-8`, Dec 2025), so shared metadata is written once on a project entry and
its versions/modules/fragments print only their delta. That release is vendored under
`style/` and picked up automatically via `.latexmkrc`, so the note builds even where the
system TeX Live predates the feature (e.g. Debian 13 ships the older v1.2-5). Once your
system `biblatex-software` is ≥ v1.2-8 everywhere, `style/` and the `.latexmkrc`
`TEXINPUTS` line can be removed.

```sh
make            # -> main.pdf
make clean
```

## Citing this note by its own SWHID

A document cannot contain its own SWHID (computing the hash would change the bytes). Instead,
build a **non-committed** stamped PDF *after* archiving the committed source:

```sh
# after committing/pushing and archiving the repo in Software Heritage:
make swhid SWHID='swh:1:dir:...;origin=...;visit=swh:1:snp:...'
# -> source-code-of-science-swhid.pdf  (git-ignored)
```

## License

Text: **CC-BY-4.0** (see `LICENSE`). Code snippets: permissive (CC0/MIT), reuse freely.

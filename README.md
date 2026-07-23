# The Source Code of Science

A doctoral course note on archiving, referencing and reproducing **research software**, built
on Software Heritage and the SWHID intrinsic identifier (ISO/IEC 18670:2025). It addresses the
FAIR principles and then goes *beyond* them. See `PLAN.md` for the full design and the
chapter-by-chapter sourcing map.

**Status:** complete — a ~74-page course note, typeset with the **memoir** class (the
*memoir edition*, v1.2). Published, archived in Software Heritage, and self-citing.

## Releases

Tagged releases carry a stamped PDF whose colophon holds the qualified SWHID of that
release's own archived source (see *Citing this note by its own SWHID* below):

| Tag | Edition |
|-----|---------|
| [v1.2](https://github.com/rdicosmo/source-code-of-science/releases/tag/v1.2) | **memoir edition** — book design, versioned title/footer, 4-step DOI figure |
| [v1.1](https://github.com/rdicosmo/source-code-of-science/releases/tag/v1.1) | restyled (running heads + provenance footer) |
| [v1.0](https://github.com/rdicosmo/source-code-of-science/releases/tag/v1.0) | first public release |

Latest stamped PDF: **[source-code-of-science-swhid.pdf](https://github.com/rdicosmo/source-code-of-science/releases/download/v1.2/source-code-of-science-swhid.pdf)**.
The human version is set by `\noteversion` in `main.tex` and shown on the title page and in
the footer; bump it to match the tag when cutting a release.

## Structure

```
main.tex            % memoir class, xelatex, biblatex + software-biblatex; \noteversion
preamble.tex        % fonts, SWH branding, memoir chapter/section style, footer, boxes, title page
chapters/01..07     % 1 Why · 2 Beyond FAIR · 3 Foundations · 4 Identifiers · 5 ARDC · 6 Reproducibility/AEC · 7 Outlook
appendix/A..F       % A cookbook · B SWHID syntax · C glossary · D SWHID tools · E policy matrix · F venue classes
references.bib      % canonical citekeys + biblatex-software entries (shared with the AEC guide)
style/              % vendored biblatex-software (crossref-capable release; see Build)
figures/ logos/     % SWH assets
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

The text, figures, and other non-code content are licensed **CC-BY-4.0** — the full legal
code is in [`LICENSE`](LICENSE). Code snippets included in the notes are additionally released
under a permissive license (CC0-1.0 / MIT), so they may be reused without attribution friction.

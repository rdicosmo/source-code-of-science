Bundled biblatex-software (crossref-capable release, bltx-v1.2-8, Dec 2025), vendored
so this note renders its own bibliography in the concise `crossrefexpansion` format on
any machine — including ones whose system TeX Live predates the feature (e.g. Debian 13
ships the older pre-crossref v1.2-5, 2022).

Source: https://ctan.org/pkg/biblatex-software  (repo: gitlab.inria.fr/gt-sw-citation/bibtex-sw-entry)
Once the system package is >= v1.2-8 everywhere you build, this style/ dir and the
.latexmkrc TEXINPUTS line may be removed.

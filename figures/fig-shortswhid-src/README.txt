Source for Figure 5.4 (fig:biblatex-swh): REAL biblatex-software output of the parmap-1.1.1
release entry, rendered with shortswhid=false (panel-false -> ../biblatex-shortswhid-full.pdf)
and shortswhid=true (panel-true -> ../biblatex-shortswhid-core.pdf). shortswhid is a load-time
option, so the two settings need two separate builds.

Regenerate:
  TEXINPUTS=../../style//: latexmk -xelatex panel-false.tex panel-true.tex
  cp panel-false.pdf ../biblatex-shortswhid-full.pdf
  cp panel-true.pdf  ../biblatex-shortswhid-core.pdf

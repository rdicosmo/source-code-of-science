NAME = main
TITLE = source-code-of-science

all: $(NAME).pdf

$(NAME).pdf: $(NAME).tex preamble.tex references.bib \
             $(wildcard chapters/*.tex) $(wildcard appendix/*.tex)
	latexmk -xelatex -interaction=nonstopmode $(NAME).tex

# Print the intrinsic identifier of the committed sources, computed offline.
# This is exactly what .latexmkrc does on every build to stamp the note, and what
# Appendix J invites the reader to run: the number below must match the one
# printed in the PDF, and the one the archive reports for this revision.
# Needs the swh CLI:  pip install swh.model
swhid:
	@test -z "$$(git status --porcelain)" || \
	  (echo "working tree has uncommitted changes: the identifier would name nothing archived" && exit 1)
	@d=$$(mktemp -d); git archive HEAD | tar -x -C "$$d"; \
	 core=$$(swh identify --type directory "$$d" 2>/dev/null | grep -o 'swh:1:dir:[0-9a-f]*'); \
	 rm -rf "$$d"; \
	 echo "$$core;origin=$(ORIGIN);anchor=swh:1:rev:$$(git rev-parse HEAD)"

ORIGIN = https://github.com/rdicosmo/source-code-of-science

clean:
	latexmk -C
	rm -f swhid.tex gitinfo.tex $(TITLE)-swhid.* main.bbl main.run.xml

.PHONY: all swhid clean

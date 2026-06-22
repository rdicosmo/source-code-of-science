NAME = main
TITLE = source-code-of-science

all: $(NAME).pdf

$(NAME).pdf: $(NAME).tex preamble.tex references.bib \
             $(wildcard chapters/*.tex) $(wildcard appendix/*.tex)
	latexmk -xelatex -interaction=nonstopmode $(NAME).tex

# Stamped, NON-committed PDF carrying the archive SWHID of the committed source.
# The source cannot contain its own SWHID (it would change the hash), so the SWHID
# is injected at build time into a throwaway copy. Workflow:
#   1) commit + push, then archive the repo in Software Heritage (Save Code Now);
#   2) copy the qualified directory SWHID from the archive "Permalinks" tab;
#   3) make swhid SWHID='swh:1:dir:...;origin=...;visit=...'
# Produces $(TITLE)-swhid.pdf (git-ignored).
swhid:
	@test -n "$(SWHID)" || (echo "usage: make swhid SWHID='swh:1:dir:...'" && exit 1)
	@printf '\\def\\thisswhid{%s}\n' '$(SWHID)' > swhid.tex
	latexmk -xelatex -interaction=nonstopmode -jobname=$(TITLE)-swhid \
	  -usepretex='\def\STAMPSWHID{1}' $(NAME).tex
	@echo "Built $(TITLE)-swhid.pdf (do not commit)."

clean:
	latexmk -C
	rm -f swhid.tex $(TITLE)-swhid.* main.bbl main.run.xml

.PHONY: all swhid clean

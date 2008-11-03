DOCNAME := paper
PDFLATEX := pdflatex --shell-escape
BIBTEX := bibtex8 -B
NOTANGLE := notangle
NOWEAVE := noweave -n

include ${DOCNAME}-deps.mk

.PHONY: doc clean

${DOCNAME}.aux: ${INCLUDES} ${DOCNAME}.tex ${DOCNAME}.bib
	${PDFLATEX} ${DOCNAME}
	${BIBTEX} ${DOCNAME}

${DOCNAME}.pdf: ${DOCNAME}.aux
	${PDFLATEX} ${DOCNAME}
	${PDFLATEX} ${DOCNAME}

${DOCNAME}-deps.mk: ${DOCNAME}.tex ${INCLUDES}
	texdepend -o $@ -print=if $<

doc: ${DOCNAME}.pdf

clean:
	@rm -frv `hg status --unknown --no-status`

numeric.oct: numeric.oct.nw
	${NOTANGLE} $< > $@

numeric.oct.tex: numeric.oct.nw
	${NOWEAVE} $< > $@

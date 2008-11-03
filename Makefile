DOCNAME := paper
PDFLATEX := pdflatex --shell-escape
BIBTEX := bibtex8 -B
NOTANGLE := notangle
NOWEAVE := noweave -n
OCTAVE := octave

include ${DOCNAME}-deps.mk

.PHONY: doc clean

${DOCNAME}.aux: ${INCLUDES} ${DOCNAME}.tex ${DOCNAME}.bib
	${PDFLATEX} ${DOCNAME}
	${BIBTEX} ${DOCNAME}

${DOCNAME}.pdf: ${DOCNAME}.aux out.oct
	${PDFLATEX} ${DOCNAME}
	${PDFLATEX} ${DOCNAME}

${DOCNAME}-deps.mk: ${DOCNAME}.tex
	texdepend -o $@ -print=if $<

doc: ${DOCNAME}.pdf

%.tkz: %.tkz.tex

clean:
	@rm -frv `hg status --unknown --no-status`

numeric.oct: numeric.oct.nw
	${NOTANGLE} $< > $@

numeric.oct.tex: numeric.oct.nw
	${NOWEAVE} $< > $@

out.oct: numeric.oct
	${OCTAVE} $<

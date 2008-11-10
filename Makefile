DOCNAME := paper
PDFLATEX := pdflatex --shell-escape
BIBTEX := bibtex8 -B
NOTANGLE := notangle
NOWEAVE := noweave -n
OCTAVE := octave
MAXIMA := maxima -b

include ${DOCNAME}-deps.mk

.PHONY: doc clean

.PRECIOUS: numeric-%.oct.out series-%.mac.out

${DOCNAME}.aux: ${INCLUDES} ${DOCNAME}.tex ${DOCNAME}.bib
	${PDFLATEX} ${DOCNAME}
	${BIBTEX} ${DOCNAME}

${DOCNAME}.pdf: ${DOCNAME}.aux numeric.oct.out series.mac.out
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

numeric-%.oct.out: numeric.oct
	echo $* | ${OCTAVE} $<

# `\input{numeric-plot-10.tkz.tex}` in TeX source makes Octave program
# run with n=10 and write results to `numeric-10.oct.out` and
# substitutes __N in plot template with 10
numeric-plot-%.tkz.tex: numeric-plot.tpl.tkz.tex numeric-%.oct.out
	m4 --define="__N"="$*" $< > $@

# Does the same for Maxima program
series-plot-%.tkz.tex: series-plot.tpl.tkz.tex series-%.mac.out
	m4 --define="__N"="$*" $< > $@

series.mac: series.mac.nw
	${NOTANGLE} $< > $@

series.mac.tex: series.mac.nw
	${NOWEAVE} $< > $@

series-%.mac.out: series.mac
	echo $*";" | ${MAXIMA} $<

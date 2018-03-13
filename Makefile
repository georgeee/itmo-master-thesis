PD=pandoc
LATEX=xelatex
BIBTEX=bibtex

THESIS=agapov-master-thesis
LATEX_FILES=$(THESIS).aux $(THESIS).bbl $(THESIS).blg $(THESIS).log $(THESIS).out $(THESIS).toc
OUT=out
INCLUDE=include
TEXT=text

clean:
	if [ -d $(OUT) ]; then cd $(OUT) && rm -Rf $(THESIS).latex $(LATEX_FILES); fi

latex: clean
	mkdir -p $(OUT)
	cd $(OUT) && pandoc --listings --toc --top-level-division=chapter -f markdown+raw_tex -t latex --template=../$(INCLUDE)/template.latex -o $(THESIS).latex `find ../$(TEXT) -name '*.pd' | sort`

pdf: latex
	cd $(OUT) && $(LATEX) $(THESIS).latex && $(BIBTEX) $(THESIS) && $(LATEX) $(THESIS).latex && $(LATEX) $(THESIS).latex


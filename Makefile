PD=pandoc
LATEX=xelatex -interaction=nonstopmode
BIBTEX=bibtex

THESIS=agapov-master-thesis-tmp
THESIS_FINAL=agapov-master-thesis
LATEX_FILES=$(THESIS).aux $(THESIS).bbl $(THESIS).blg $(THESIS).log $(THESIS).out $(THESIS).toc
OUT=out
INCLUDE=include
TEXT=text

clean:
	if [ -d $(OUT) ]; then cd $(OUT) && rm -Rf $(THESIS).latex $(LATEX_FILES); fi

latex: clean
	mkdir -p $(OUT)
	cd $(OUT) && $(PD) --listings --toc --top-level-division=chapter -f markdown+raw_tex+multiline_tables -t latex --template=../$(INCLUDE)/template.latex -o $(THESIS).latex `find ../$(TEXT) -name '*.pd' | sort`

pdf: latex
	cd $(OUT) && rm -f latex.error && \
	 { $(LATEX) $(THESIS).latex; $(BIBTEX) $(THESIS); $(LATEX) $(THESIS).latex; $(LATEX) $(THESIS).latex \
	              && mv $(THESIS).pdf $(THESIS_FINAL).pdf; \
	 } >> latex.error && echo $(THESIS_FINAL).pdf generated \
	|| { mv latex.error error.log; echo ''; echo '==================='; echo ''; echo "Error detected"; echo less $(OUT)/error.log; }

cut:
	pdftk out/agapov-master-thesis-tmp.pdf cat 2 4-44 output out/agapov-master-thesis-tmp1.pdf
	mv out/agapov-master-thesis-tmp1.pdf out/agapov-master-thesis-tmp.pdf

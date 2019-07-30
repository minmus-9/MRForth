########################################################################
### Makefile
###

PDFLATEX=pdflatex

all:	MANUAL.pdf

docs:	all

MANUAL.pdf:	MANUAL.tex
	$(PDFLATEX) MANUAL.tex; $(PDFLATEX) MANUAL.tex

view:	MANUAL.pdf
	~/DD/foxit MANUAL.pdf &

install:	all

uninstall:	

tidy:	
	/bin/rm -f *.aux *.log *~

clean:	tidy

distclean:	clean
	/bin/rm -f *.pdf

### EOF Makefile


########################################################################
### Makefile
###

all:	code docs

code:	
	cd src && $(MAKE) all

docs:	
	cd docs && $(MAKE) all

bundle:
	BASE=MRForth-`TZ=UTC date +%Y%m%d%H%M%SZ`; \
	git archive --format=tar --prefix=$$BASE/ HEAD > $$BASE.tar; \
	xz $$BASE.tar

dist:	install docs tidy
	cd .. && (rm -f mrforth.zip; zip -r mrforth.zip mrforth -x '*CVS*')

tags:	
	cvs status -v src/Makefile | sed -ne '/Existing/,$$p' | tac

tag:	
	@[ -n "$$TAG" ] || { echo "you must set TAG!"; exit 1; }
	@cvs tag "$(TAG)"

commit:	
	@[ -n "$$M" ] || M=ok; \
	cvs commit -m "$$M"

run:	
	cd src && $(MAKE) run

install:	
	cd docs && $(MAKE) install
	cd src  && $(MAKE) install

uninstall:	
	cd docs && $(MAKE) uninstall
	cd src  && $(MAKE) uninstall

tidy:	
	cd docs && $(MAKE) tidy
	cd src  && $(MAKE) tidy

clean:	
	cd docs && $(MAKE) clean
	cd src  && $(MAKE) clean
	/bin/rm -f *.stackdump core* MRForth-[0-9][0-9]*Z.tar.xz

distclean:	clean
	cd docs && $(MAKE) distclean
	cd src  && $(MAKE) distclean

### EOF Makefile


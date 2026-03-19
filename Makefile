.PHONY: all clean

PANDOC := pandoc

SRCDIR := src
OUTDIR := site

MDFILES := $(wildcard $(SRCDIR)/*.md)
HTMLFILES := ${MDFILES:$(SRCDIR)/%.md=$(OUTDIR)/%.html}
LANDINGTEMPLATE := templates/landing.html
SIMPLETEMPLATE := templates/simple.html
SYNTAXDEF := templates/fram.xml

all: $(HTMLFILES) $(OUTDIR)/css $(OUTDIR)/img

$(OUTDIR)/index.html: $(SRCDIR)/index.md $(LANDINGTEMPLATE) $(SYNTAXDEF) | $(OUTDIR)
	$(PANDOC) -s -t html \
		--template $(LANDINGTEMPLATE) \
		--syntax-definition $(SYNTAXDEF) \
		-o $(OUTDIR)/index.html $(SRCDIR)/index.md

$(OUTDIR)/%.html: $(SRCDIR)/%.md $(SIMPLETEMPLATE) $(SYNTAXDEF) | $(OUTDIR)
	$(PANDOC) -s -t html \
		--template $(SIMPLETEMPLATE) \
		--syntax-definition $(SYNTAXDEF) \
		-o $@ $<

$(OUTDIR)/css: css | $(OUTDIR)
	cp -r css $(OUTDIR)

$(OUTDIR)/img: $(SRCDIR)/img | $(OUTDIR)
	cp -r $(SRCDIR)/img $(OUTDIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

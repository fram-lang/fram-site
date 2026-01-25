.PHONY: all clean

PANDOC := pandoc

SRCDIR := src
OUTDIR := site

MDFILES := $(wildcard $(SRCDIR)/*.md)
HTMLFILES := ${MDFILES:$(SRCDIR)/%.md=$(OUTDIR)/%.html}
TEMPLATES := templates/landing.html templates/fram.xml

all: $(HTMLFILES) $(OUTDIR)/css $(OUTDIR)/img

$(OUTDIR)/index.html: $(SRCDIR)/index.md $(TEMPLATES) | $(OUTDIR)
	$(PANDOC) -s -t html \
		--template templates/landing.html \
		--syntax-definition templates/fram.xml \
		-o $(OUTDIR)/index.html $(SRCDIR)/index.md

$(OUTDIR)/css: css | $(OUTDIR)
	cp -r css $(OUTDIR)

$(OUTDIR)/img: $(SRCDIR)/img | $(OUTDIR)
	cp -r $(SRCDIR)/img $(OUTDIR)

$(OUTDIR):
	mkdir -p $(OUTDIR)

clean:
	rm -rf $(OUTDIR)

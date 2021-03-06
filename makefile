##------------------------------------------------------------------------------------##
##------------------------------------------------------------------------------------##
## Content: Open-Science-Paper LaTeX-Makefile
## Usage: Compile Open-Science-Papers  
## Author: Claas-Thido Pfaff
##------------------------------------------------------------------------------------##
##------------------------------------------------------------------------------------##

# Maindocument
DOCUMENT = open_science_paper

# Dependencies maindocument
DEPENDENCIES = $(DOCUMENT).Rnw osp/subdocuments/open_science_paper.* usr/subdocuments/open_science_paper.* usr/subdocuments/*.Rnw osp/data/*.csv

# Used Programs
KNITR = knit
BIBTEX = biber 
LUALATEX = lualatex
PDFLATEX = pdflatex 
PACKER= tar -czf
REMOVER = @-rm -r
PRINTER = @-echo 
GREPPER = @-grep  
RIGHTSETTER = @-chmod
COPY = @-cp
PDFVIEWER = okular
DATE = $(shell date +%y%m%d)

# Example and Empty files  
SUBDOCFOLDER = usr/subdocuments/
EXMPLDOCS = osp/subdocuments/exmpl/*.bib osp/subdocuments/exmpl/*.sty osp/subdocuments/exmpl/*.Rnw 
TEMPDOCS = osp/subdocuments/temp/*.bib osp/subdocuments/temp/*.sty osp/subdocuments/temp/*.Rnw 
TEMPREADME = osp/subdocuments/temp/README.md
EXMPLREADME = osp/subdocuments/exmpl/README.md  

# Base folder 
BASEFOLDER = `pwd` 

# Git hooks 
HOOKSOURCE = osp/data/ospGitHook
GITHOOKPATH = .git/hooks
HOOKRIGHTS = 744

# Archive document
ARCHNAME = $(DOCUMENT)_$(DATE).tar.gz
ARCHFILES = $(DOCUMENT).pdf $(DOCUMENT).Rnw usr/subdocuments data usr/graphics makefile

# Clean up the document folder
CLEANFILES = usr/graphics/dynamic/* *.gin usr/cache/* *.xdy *tikzDictionary *.idx *.mtc* *.glo *.maf *.ptc *.tikz *.lot *.dpth *.figlist *.dep *.log *.makefile *.out *.map *.tex *.toc *.aux *.tmp *.bbl *.blg *.lof *.acn *.acr *.alg *.glg *.gls *.ilg *.ind *.ist *.slg *.syg *.syi *.acn *.dvi *.ist *.syg *.synctex.gz *.bcf *.run.xml *-blx.bib  

# Default rule
all: $(DOCUMENT).pdf 

$(DOCUMENT).pdf: $(DEPENDENCIES)  
	$(KNITR) $(DOCUMENT).Rnw $(DOCUMENT).tex --no-convert
	$(PDFLATEX) $(DOCUMENT).tex
	$(PDFLATEX) $(DOCUMENT).tex
	$(BIBTEX) $(DOCUMENT)
	$(PDFLATEX) $(DOCUMENT).tex

uselua: $(DEPENDENCIES)  
	$(KNITR) $(DOCUMENT).Rnw $(DOCUMENT).tex --no-convert
	$(LUALATEX) $(DOCUMENT).tex
	$(LUALATEX) $(DOCUMENT).tex
	$(BIBTEX) $(DOCUMENT)
	$(LUALATEX) $(DOCUMENT).tex

# Special rules
showpdf:
	$(PDFVIEWER) $(DOCUMENT).pdf & 

warnings:
	$(PRINTER) "----------------------------------------------------o"
	$(PRINTER) "Multiple defined lables!"
	$(PRINTER) ""
	$(GREPPER) 'multiply defined' $(DOCUMENT).log
	$(PRINTER) "----------------------------------------------------o"
	$(PRINTER) "Undefined lables!"
	$(PRINTER) ""
	$(GREPPER) 'undefined' $(DOCUMENT).log
	$(PRINTER) "----------------------------------------------------o"
	$(PRINTER) "Warnings!"
	$(PRINTER) ""
	$(GREPPER) 'Warning' $(DOCUMENT).log
	$(PRINTER) "----------------------------------------------------o"
	$(PRINTER) "Over- and Underfull boxes!"
	$(PRINTER) ""
	$(GREPPER) 'Overfull' $(DOCUMENT).log
	$(GREPPER) 'Underfull' $(DOCUMENT).log
	$(PRINTER) "----------------------------------------------------o"

archive:
	$(PACKER) $(ARCHNAME) $(ARCHFILES)

clean:
	$(REMOVER) $(CLEANFILES)	

exmpldoc:
	$(COPY) $(EXMPLDOCS) $(SUBDOCFOLDER) 
	$(COPY) $(EXMPLREADME) $(BASEFOLDER) 

tmpdoc:
	$(COPY) $(TEMPDOCS) $(SUBDOCFOLDER)  
	$(COPY) $(TEMPREADME) $(BASEFOLDER) 

githooks:  
	$(COPY) $(HOOKSOURCE) $(GITHOOKPATH)/post-checkout 
	$(COPY) $(HOOKSOURCE) $(GITHOOKPATH)/post-commit 
	$(COPY) $(HOOKSOURCE) $(GITHOOKPATH)/post-merge 
	$(RIGHTSETTER) $(HOOKRIGHTS) $(GITHOOKPATH)/* 

prep:
	$(COPY) usr/subdocuments/open_science_paper.sty usr/subdocuments/osp_global_knitr_options.Rnw osp/subdocuments/exmpl/
	$(COPY) usr/subdocuments/open_science_paper.sty usr/subdocuments/osp_global_knitr_options.Rnw osp/subdocuments/temp/ 
	$(COPY) README.md osp/subdocuments/exmpl/

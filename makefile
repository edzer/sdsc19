all:
	vi sdsc.Rmd
	Rscript -e 'rmarkdown::render("sdsc.Rmd")'
	Rscript -e 'knitr::purl("sdsc.Rmd")'
	cp sdsc.html docs/index.html

view:
	google-chrome docs/index.html

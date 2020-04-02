all: build_site

build_site: 
	Rscript -e "pkgdown::build_site(pkg = '.')"

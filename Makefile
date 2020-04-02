all: build_site make_r_profile

make_r_profile:
	echo "options(encoding = 'UTF-8')" > .Rprofile

build_site: 
	Rscript -e "options(encoding = 'UTF-8'); pkgdown::build_site(pkg = '.')"

# Dev utility
# How to use: make -f dev.mk

.DEFAULT_GOAL := help

all: document check build_site

document: ## document functions
	Rscript -e "devtools::document()"

check: ## check package build
	Rscript -e "devtools::check()"

build_site: ## build pkgdown site
	Rscript -e "pkgdown::build_site()"

.PHONY: clean
clean: ## remove junk things
	rm -f output/*

help: ## show all commands
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: build_deploy make_gif

make_gif:
	Rscript -e "devtools::load_all(); \
	dados <- get_corona_br(by_uf = TRUE); \
	dados_format <- format_corona_br(dados); \
	plot_uf(df = dados_format, anim = TRUE, dir = 'vignettes/figs'); \
	if (file.exists('Rplots.pdf')) {; \
	  file.remove('Rplots.pdf'); \
	  file.remove(list.files(path = 'output', pattern = '*.csv', full.names = TRUE), recursive = TRUE)}"

build_deploy: make_gif
	Rscript -e "devtools::build_site('.')"

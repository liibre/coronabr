#' Extrai dados mundiais de corona vírus
#'
#' Esta função extrai os valores compilados pela Johns Hopkins University (disponível em: 'https://github.com/CSSEGISandData/COVID-19') e salva o resultado no disco.
#'
#' @inheritParams get_corona
#'
#' @importFrom readr read_csv write_csv
#' @importFrom glue glue
#' @importFrom janitor clean_names
#' @importFrom fs dir_create
#' @import magrittr
#'
#' @export
#'
get_corona_jhu <- function(dir = "output",
                           filename = "corona_jhu") {

  message(glue::glue("Criando diretorio {dir} ...\n\n"))

  message("Baixando dados atualizados ...\n\n")

  yesterday <- format(as.Date(Sys.Date() - 1, '%Y-%m-%d'), "%m-%d-%Y")

  link <-
    glue::glue("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/{yesterday}.csv")

  covid_data <-
    readr::read_csv(link) %>%
    janitor::clean_names(dat = ., case = "snake")

  fs::dir_create(dir)

  message(glue::glue("Salvando {filename}.csv em {dir} ...\n\n"))

  save_filename <- paste0(paste(dir, filename, sep = "/"), ".csv")

  covid_data %>%
    readr::write_csv(x = ., path = save_filename)

}

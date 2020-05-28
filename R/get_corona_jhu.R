#' Extrai dados mundiais de coronavírus
#'
#' Esta função extrai os valores compilados pela Johns Hopkins University (disponível em: 'https://github.com/CSSEGISandData/COVID-19') e salva o resultado no disco.
#'
#' @inheritParams get_corona_minsaude
#'
#' @importFrom magrittr %>%
#' @importFrom stats setNames
#'
#' @export
#'
get_corona_jhu <- function(dir = "outputs",
                           filename = "corona_jhu") {

  message("Baixando dados atualizados ...\n\n")

  yesterday <- format(as.Date(Sys.Date() - 1, '%Y-%m-%d'), "%m-%d-%Y")

  link <-
    paste0("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_daily_reports/",
           yesterday, ".csv")

  covid_data <-
    read.csv(link) %>%
    setNames(tolower(gsub("_$", "", names(.))))

  # metadado
  # gravando metadados da requisicao
  metadado <- data.frame(ultima_atualizacao = unique(covid_data$last_update),
                         fonte = "https://coronavirus.jhu.edu",
                         acesso_em = Sys.Date())

  if (!dir.exists(dir)) dir.create(dir)

  message(paste0("salvando ", filename, ".csv em ", dir))

  save_filename <- paste0(dir, "/", filename, ".csv")

  write.csv(covid_data, save_filename, row.names = FALSE)
  write.csv(metadado,
            paste0(dir, "/", filename, "_metadado.csv"),
            row.names = FALSE)

  return(covid_data)

}

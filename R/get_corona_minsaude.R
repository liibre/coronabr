#' Extrai dados de COVID-19 para o Brasil da página do Ministério da Saúde
#'
#' Esta função extrai os valores compilados pelo Ministério da Saúde do Brasil
#' (disponíveis em: 'https://covid.saude.gov.br/') e salva o resultado no disco.
#'
#' @param dir Diretório onde salvar o arquivo
#' @param filename Nome do arquivo, valor predeterminado "minsaude"
#' @param uf Caractere indicando a abreviação do(s) estado(s) brasileiro(s)
#'
#' @importFrom utils write.csv
#' @importFrom dplyr mutate_if bind_rows left_join
#' @importFrom rlang .data
#' @importFrom utils read.csv write.csv
#' @importFrom magrittr %>%
#' @importFrom plyr .
#' @importFrom lubridate as_date
#'
#' @export
#'
get_corona_minsaude <- function(dir = "output",
                                filename = "minsaude",
                                uf = NULL) {
  rlang::.data #para usar vars no dplyr
  #get original data and format it
  url <-
    httr::GET("https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalGeral",
              httr::add_headers("X-Parse-Application-Id" =
                            "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")) %>%
    httr::content() %>%
    '[['("results") %>%
    '[['(1) %>%
    '[['("arquivo") %>%
    '[['("url")
  #url <- "https://covid.saude.gov.br"
  #date <- format(Sys.Date(), "%Y%m%d")
  res <- utils::read.csv2(url, stringsAsFactors = FALSE, fileEncoding = "latin1")
  #datas boas
  #dplyr::mutate(date = lubridate::as_date(as.character(.data$data),
     #                                       tz = "America/Sao_Paulo")
      #                                      format = "%d/%m/%Y")) %>%
  #datas de excel
  # datas <- chron::month.day.year(jul = res$data, origin. = c(1, 1, 1900))
  # res$date <- as.Date(
  #   paste(datas$year, datas$month, datas$day, sep = "-"))
  # res <- res %>% dplyr::select(-.data$data)
  res$date <- lubridate::dmy(res$date)
  # gravando metadados da requisicao
  metadado <- data.frame(intervalo = paste(range(res$date), collapse = ";"),
                         fonte = url,
                         acesso_em = Sys.Date())
  if (!is.null(uf)) {
    res <- res %>% dplyr::filter(.data$sigla %in% uf)
  }

  message(paste0("salvando ", filename, ".csv em ", dir))
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  utils::write.csv(res,
                   paste0(dir, "/", filename,
                          paste(uf, collapse = "-"), ".csv"),
                   row.names = FALSE)
  utils::write.csv(metadado,
                   paste0(dir, "/", "metadado_minsaude",
                          paste(uf, collapse = "-"), ".csv"),
                   row.names = FALSE)
  return(res)
}

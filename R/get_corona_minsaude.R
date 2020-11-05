#' Extrai dados de COVID-19 para o Brasil da página do Ministério da Saúde
#'
#' Esta função extrai os valores compilados pelo Ministério da Saúde do Brasil
#' (disponíveis em: 'https://covid.saude.gov.br/') e salva o resultado no disco.
#'
#' @param dir Diretório onde salvar o arquivo
#' @param filename Nome do arquivo, valor predeterminado "minsaude"
#' @param uf Caractere indicando a abreviação do(s) estado(s) brasileiro(s)
#' @param save Lógico. Salva os dados na pasta `dir`
#'
#' @importFrom utils write.csv unzip
#' @importFrom dplyr mutate_if bind_rows left_join
#' @importFrom rlang .data
#' @importFrom utils read.csv write.csv
#' @importFrom magrittr %>%
#' @importFrom plyr .
#' @importFrom vroom vroom
#'
#' @export
#'
get_corona_minsaude <- function(dir = "outputs",
                                filename = "minsaude",
                                uf = NULL,
                                save = TRUE) {
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


  message("Baixando dados do Min. da Sa\u00fade...")
  # now with read.xlsx because it is faster
  #res <- openxlsx::read.xlsx(url, detectDates = TRUE)
  #it's a ZIP inside a csv again so we have to go back to donwload and unzip (unless...)
    tmp_data <- file.path(dir, "temporary_data")
    utils::download.file(url, tmp_data)
    utils::unzip(tmp_data, exdir = dir)
    file <- list.files(dir, pattern = "HIST_PAINEL", full.names = T)
    res <- vroom::vroom(file)

  res <- dplyr::mutate_at(res, dplyr::vars(dplyr::contains(c("Acumulado", "Novos", "novos"))), ~ as.numeric(.))

  #url <- "https://covid.saude.gov.br"
  #date <- format(Sys.Date(), "%Y%m%d")
  # res <- utils::read.csv2(url, stringsAsFactors = FALSE, fileEncoding = "latin1")
  #datas boas
  #dplyr::mutate(date = lubridate::as_date(as.character(.data$data),
     #                                       tz = "America/Sao_Paulo")
      #                                      format = "%d/%m/%Y")) %>%
  #datas de excel
  # datas <- chron::month.day.year(jul = res$data, origin. = c(1, 1, 1900))
  # res$date <- as.Date(
  #   paste(datas$year, datas$month, datas$day, sep = "-"))
  # res <- res %>% dplyr::select(-.data$data)
  #res$date <- as.Date(res$data)
  # gravando metadados da requisicao
  metadado <- data.frame(intervalo = paste(range(res$data), collapse = ";"),
                         fonte = url,
                         acesso_em = Sys.Date())
  if (!is.null(uf)) {
    res <- res %>% dplyr::filter(.data$estado %in% uf)
  }

  if (save) {
  message(paste0("salvando ", filename, ".csv em ", dir))

  if (!dir.exists(dir)) dir.create(dir)

  utils::write.csv(res,
                   paste0(dir, "/", filename, ".csv"),
                   row.names = FALSE)
  utils::write.csv(metadado,
                   paste0(dir, "/", filename, "_metadado.csv"),
                   row.names = FALSE)
  }

  return(res)

}

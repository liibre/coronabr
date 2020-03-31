#' Extrai dados de coronavírus para o Brasil de Brasil.io
#'
#' Esta função extrai os valores compilados pelo portal Brasil.io, que recolhe boletins informativos e casos do coronavírus por minicípio e por dia (disponível em: https://brasil.io/dataset/covid19/caso). A função salva o resultado no disco e escreve um arquivo com os metadados da requisição (metadado_corona_br.csv).
#'
#' @inheritParams get_corona
#'
#' @param cidade Caractere indicando o(s) nome(s) do(s) município(s) brasileiro(s). Atenção, fornecer também o estado ou o código ibge para evitar ambiguidade. "Importados" extrai os casos importados, se disponíveis.
#' @param uf Caractere indicando a abreviação do(s) estado(s) brasileiro(s)
#' @param ibge_cod Numérico ou caractere. Código ibge do(s) município(s) ou estado(s) brasileiro(s). O código dos municípios tem 7 cifras e o código dos estados 2
#' @param by_uf Lógico. Padrão by_uf = FALSE. Usar by_uf = TRUE se quiser os dados apenas por UF independente do município. Usar apenas quando não fornecer `cidade` ou `ibge_cod` de um município
#'
#' @importFrom dplyr filter
#' @importFrom utils read.csv
#' @importFrom utils write.csv
#' @importFrom rlang .data
#' @importFrom magrittr %>%
#'
#' @export
#'
get_corona_br <- function(dir = "output",
                          filename = "corona_brasil",
                          cidade = NULL,
                          uf = NULL,
                          ibge_cod = NULL,
                          by_uf = FALSE){
  # my_urls <- c('https://brasil.io/api/dataset/covid19/caso/data',
  #              'https://brasil.io/api/dataset/covid19/caso/data?page=2')
  # res_list <- lapply(my_urls, function(x) jsonlite::fromJSON(x)$results)
  # res <- dplyr::bind_rows(res_list)
  # baixando direto o csv pq api retorna datas diferentes a casa requisicao
  res <- utils::read.csv("https://brasil.io/dataset/covid19/caso?format=csv")
  res$date <- as.Date(res$date)
  # gravando metadados da requisicao
  metadado <- data.frame(intervalo = paste(range(res$date), collapse = ";"),
                         fonte = "https://brasil.io/dataset/covid19/caso",
                         acesso_em = Sys.Date())
    if (!is.null(cidade) & is.null(uf)) {
    stop("Precisa fornecer um estado para evitar ambiguidade")
  }
  if (!is.null(cidade)) {
    if (sum(!cidade %in% unique(res$city)) > 0) {
      stop("algum nome de municipio em 'city' invalido ou ainda nao ha dados/casos para essa cidade")
    }
    if (sum(!uf %in% unique(res$state) > 0)) {
      stop("algum nome de estado em 'state' invalido ou ainda nao ha dados/casos para essa cidade")
    }
    if (!is.null(cidade) & !is.null(uf)) {
      res <- res %>% dplyr::filter(.data$state %in% uf
                                   & .data$city %in% cidade)
    }
  } else {
    res <- res
  }
  if (!is.null(ibge_cod)) {
    if (sum(!ibge_cod %in% unique(res$city_ibge_code)) > 0) {
      stop("algum codigo de municipio ou estado 'ibge_code' invalido")
    } else {
      res <- res %>% dplyr::filter(.data$city_ibge_code %in% ibge_cod)
    }
  } else {
    res <- res
  }
  if (is.null(cidade) & is.null(ibge_cod) & !is.null(uf)) {
    res <- res %>% dplyr::filter(.data$state %in% uf)
  }
  if (is.null(cidade) & is.null(ibge_cod) & is.null(uf)) {
    res <- res
  }
  if (by_uf == TRUE) {
    res <- res %>% filter(.data$place_type == "state")
  }
  # mudancas para facilitar plots
  res$date <- as.Date(res$date)
  res$state <- as.factor(res$state)
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  utils::write.csv(res, paste0(dir, "/", filename, ".csv"),
                   row.names = FALSE)
  utils::write.csv(metadado, paste0(dir, "/", "metadado_corona_br", ".csv"),
                   row.names = FALSE)
  return(res)
}

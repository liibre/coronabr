#' Extrai dados de corona vírus para o Brasil de O Brasil em dados abertos
#'
#' Esta função extrai os valores compilados pelo portal Brasil.io, que recolhe boletins informativose casos do coronavírus por minicípio e por dia (disponível em: https://brasil.io/dataset/covid19/caso) e salva o resultado no disco.
#'
#' @inheritParams get_corona
#'
#' @param cidade Caractere indicando o(s) nome(s) do(s) município(s) brasileiro(s). Atenção, fornecer também o estado para evitar ambiguidade
#' @param uf Caractere indicando a abreviação do(s) estado(s) brasileiro(s)
#' @param cidade_ibge_cod Numérico ou caractere. Código ibge do(s) município(s) brasileiro(s)
#'
#' @importFrom dplyr filter
#' @importFrom jsonlite fromJSON
#' @importFrom utils write.csv
#' @importFrom rlang .data
#' @import magrittr
#'
#' @export
#'
get_corona_br <- function(dir = "output/",
                          filename = "corona_brasil",
                          cidade = NULL,
                          uf = NULL,
                          cidade_ibge_cod = NULL){
  my_url <- 'https://brasil.io/api/dataset/covid19/caso/data'
  res <- jsonlite::fromJSON(my_url)$results
  if (!is.null(cidade) & is.null(uf)) {
    stop("Precisa fornecer um estado para evitar ambiguidade")
  }
  if (!is.null(cidade)) {
    if (sum(!cidade %in% unique(res$city)) > 0) {
      stop("algum nome de municipio em 'city' invalido")
    }
    if (sum(!uf %in% unique(res$state) > 0)) {
      stop("algum nome de estado em 'state' invalido")
    }
    if (!is.null(cidade) & !is.null(uf)) {
      res <- res %>% dplyr::filter(.data$state %in% uf
                                   & .data$city %in% cidade)
    }
  } else {
    res <- res
  }
  if (!is.null(cidade_ibge_cod)) {
    if (sum(!cidade_ibge_cod %in% unique(res$city_ibge_code)) > 0) {
      stop("algum codigo de municipio 'city_ibge_code' invalido")
    } else {
    res <- res %>% dplyr::filter(.data$city_ibge_code %in% cidade_ibge_cod)
    }
  } else {
    res <- res
  }
   if (is.null(cidade) & is.null(cidade_ibge_cod) & !is.null(uf)) {
     res <- res %>% dplyr::filter(.data$state %in% uf)
   }
   if (is.null(cidade) & is.null(cidade_ibge_cod) & is.null(uf)) {
     res <- res
   }
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  utils::write.csv(res, paste0(dir, filename, ".csv"),
                   row.names = FALSE)
  return(res)
}

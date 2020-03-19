#' Extrai dados de corona vírus para o Brasil
#'
#' Esta função extrai os valores compilados pelo ministério da Saúde do Brasil (disponível em: 'http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil') e salva o resultado no disco.
#'
#' @param dir diretório onde salvar o arquivo
#' @param filename nome do arquivo
#'
#' @export
#'
get_corona <- function(dir = "output/", filename = "corona_brasil") {
  new_df <- "http://plataforma.saude.gov.br/novocoronavirus/resources/scripts/database.js" %>%
    readr::read_file() %>%
    stringr::str_remove("var database=") %>%
    jsonlite::fromJSON() %>%
    purrr::pluck("brazil") %>%
    dplyr::mutate(values = purrr::map(values, dplyr::mutate_all, as.character)) %>%
    tidyr::unnest(values) %>%
    dplyr::mutate(date = lubridate::dmy(date)) %>%
    dplyr::mutate(id_date = as.integer(as.factor(date))) %>%
    dplyr::mutate(local = dplyr::if_else(local == "FALSE", "0", local)) %>%
    tidyr::replace_na(list(
      suspects = 0, refuses = 0,
      confirmado = 0, deads = 0,
      local = 0, cases = 0, deaths = 0)
    ) %>%
    dplyr::select(
      id_date, date, uid, suspects, refuses, confirmado, deads,
      local, cases, deaths
    ) %>%
    dplyr::mutate_at(
      dplyr::vars(suspects, refuses, confirmado, deads, local, cases, deaths),
      as.numeric
    )
  dir.create(dir, FALSE, TRUE)
  utils::write.csv(new_df, paste0(dir, filename, ".csv"), row.names = FALSE)
  return(new_df)
}

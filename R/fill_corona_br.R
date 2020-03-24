#' Preenche as datas vazias nos dados de COVID-19 do Brasil.io
#'
#' Dado que na ausência da emissão do boletim por alguma secretaria, a data é excluída das planilhas, incluímos a opção de preencher a lacuna com os dados do último boletim. O preenchimento é apenas para os municípios e estados com casos registrados.
#'
#' @inheritParams plot_corona_br
#'
#' @export
#'
#'
fill_corona_br <- function(df){
  datas <- expand.grid(date =  seq(min(df$date), max(df$date), by = 1),
                       city_ibge_code = unique(df$city_ibge_code))
  datas$city_ibge_code <- as.character(datas$city_ibge_code)
  df$city_ibge_code <- as.character(df$city_ibge_code)
  df_datas <- dplyr::right_join(df, datas,
                                by = c("city_ibge_code", "date"))
  # preenchendo
  df_new <- df_datas %>%
    dplyr::group_by(.data$city_ibge_code) %>%
    dplyr::arrange(.data$city_ibge_code) %>%
    dplyr::arrange(.data$date) %>%
    tidyr::fill(.data$confirmed, .data$confirmed_per_100k_inhabitants,
                .data$deaths, .data$death_rate,
                .direction = "down") %>%
    dplyr::mutate(confirmed = tidyr::replace_na(.data$confirmed, 0),
                  confirmed_per_100k_inhabitants = tidyr::replace_na(.data$confirmed_per_100k_inhabitants, 0),
                  deaths = tidyr::replace_na(.data$deaths, 0),
                  death_rate = tidyr::replace_na(.data$death_rate, 0)) %>%
    dplyr::ungroup()
  return(df_new)
}

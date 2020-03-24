#' Mapa do número de casos por estado
#'
#' Esta função faz o mapa do número de casos por estado brasileiro.
#'
#' @inheritParams plot_corona_br
#' @inheritParams map_corona_br
#'
#' @export
#'
#' @importFrom brazilmaps get_brmap
#' @importFrom sf st_as_sf
#' @importFrom rlang .data

gif_corona_br <- function(df,
                          prop_pop = TRUE){
  # puxando a data mais atualizada
  df$date <- as.Date(df$date)
  datas <- plyr::count(df$date[df$confirmed > 0])
  datas$lag <- datas$freq - dplyr::lag(datas$freq)
  if (datas$lag[which.max(datas$x)] < 0) {
    data_max <- max(datas$x, na.rm = TRUE) - 1
  } else {
    data_max <- max(datas$x, na.rm = TRUE)
  }
  df <- df %>%
    filter(.data$date <= data_max)
  df$Casos <- df$confirmed
  # proporcao de casos por 100k
  df$`Casos (por 100 mil hab.)` <- df$confirmed_per_100k_inhabitants
  df$State <- df$city_ibge_code
  # importa shapefile estados
  br <- brazilmaps::get_brmap(geo = "State",
                              class = "sf")
  # juntando o df ao shape
  br_sf <- sf::st_as_sf(br) %>%
    merge(df, by = "State")
  # mapa
  anim <- tmap::tm_shape(br) +
    tmap::tm_fill(col = "white") +
    tmap::tm_borders() +
    tmap::tm_shape(br_sf) +
    tmap::tm_fill(colorNA = "white") +
    tmap::tm_borders() +
    tmap::tm_facets(along = "date", free.coords = FALSE) +
    if (prop_pop == TRUE) {
      tmap::tm_symbols(size = "Casos (por 100 mil hab.)",
                       border.col = "red",
                       col = "red",
                       scale = 2,
                       alpha = 0.7)
    } else {
      tmap::tm_symbols(size = "Casos",
                       border.col = "red",
                       col = "red",
                       scale = 2,
                       alpha = 0.7)
    }
anim
}

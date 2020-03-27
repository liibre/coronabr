#' Mapa do número de casos por estado
#'
#' Esta função faz o mapa do número de casos por estado brasileiro.
#'
#' @param df Data frame formatado com a função `format_corona_br()`
#' @param prop_pop Lógico. Exibir gráfico com número de casos proporcional à população? Padrão prop_pop = TRUE
#' @param anim Lógico. Retornar animação com evolução do número de casos ao longo do tempo. Padrão anim = FALSE
#'
#' @export
#'
#' @importFrom brazilmaps get_brmap
#' @importFrom sf st_as_sf
#' @importFrom rlang .data

map_corona_br <- function(df,
                          prop_pop = TRUE,
                          anim = FALSE){
  # puxando a data mais atualizada
  df$date <- as.Date(df$date)
  datas <- plyr::count(df$date[df$confirmed > 0])
  datas$lag <- datas$freq - dplyr::lag(datas$freq)
  if (datas$lag[which.max(datas$x)] < 0) {
    data_max <- max(datas$x, na.rm = TRUE) - 1
  } else {
    data_max <- max(datas$x, na.rm = TRUE)
  }
  if (anim == FALSE) {
  df <- df %>%
    filter(.data$date == data_max)
  }
  df$Casos <- df$confirmed
  # proporcao de casos por 100k
  df$`Casos (por 100 mil hab.)` <- df$confirmed_per_100k_inhabitants
  df$State <- df$city_ibge_code
  br <- brazilmaps::get_brmap(geo = "State",
                              class = "sf")

  br_sf <- sf::st_as_sf(br) %>%
    merge(df, by = "State")
  # mapa
  mapa <- tmap::tm_shape(br) +
    tmap::tm_fill(col = "white") +
    tmap::tm_borders() +
    tmap::tm_shape(br_sf) +
    tmap::tm_fill(colorNA = "white") +
    tmap::tm_borders() +
    if (prop_pop == TRUE) {
      tmap::tm_symbols(size = "Casos (por 100 mil hab.)",
                       col = "red",
                       border.col = "red",
                       scale = 2,
                       alpha = 0.7)
    } else {
      tmap::tm_symbols(size = "Casos",
                       col = "red",
                       border.col = "red",
                       scale = 2,
                       alpha = 0.7)
    }
  if (anim == TRUE) {
     anim <- mapa +
       tmap::tm_facets(along = "date", free.coords = FALSE)
     #ö: maybe animate here? i did that
     anim <- tmap::tmap_animation(anim,
                                  filename = "figs/anim.gif",
                                  delay = 25,
                                  width = 1200,
                                  height = 1200,
                                  restart.delay = 50)
     return(anim)
   }
  mapa
}

#' Plot o número de casos (confirmados ou óbitos) por Estados com dados do Brasil.io
#'
#' @param df Data frame por estado formatado com a função `format_corona_br()`
#' @param tipo Variável a ser exibida no eixo y. Padrão `tipo = "casos"` para mostrar os casos confirmados. Use `tipo = "obitos"` para o gráfico com o número de óbitos
#' @param prop_pop Lógico. Exibir gráfico com número de casos proporcional à população? Padrão prop_pop = TRUE.
#' @param n Inteiro. Número mínimo de estados para o gráfico
#' @param estados Caractere. Quais estados plotar (ex. c("PI", "CE"))
#'
#' @importFrom dplyr filter mutate glimpse
#' @importFrom stats reorder setNames
#' @import ggplot2
#' @importFrom rlang .data
#' @importFrom stats na.omit
#'
#' @return objeto ggplot
#'
#' @examples
#' \dontrun{
#' dados <- get_corona_br(by_uf = TRUE)
#' dados_format <- format_corona_br(dados)
#' plot_uf(df = dados_format)
#' }
#' @export
#'
plot_uf <- function(df,
                    prop_pop = TRUE,
                    tipo = "casos",
                    n = 10,
                    estados = NULL) {


  # remove na
  df$state <- as.character(df$state)
  if (tipo == "casos") {
    df$var <- df$last_available_confirmed
    leg_y <- paste0("N", "\u00fa", "mero de casos confirmados")
    if (prop_pop) {
      leg_y <- paste(leg_y, "por cem mil habitantes")
      df$var <- df$last_available_confirmed_per_100k_inhabitants
    }
  } else {
    df$var <- df$last_available_deaths
    leg_y <- paste0("N", "\u00fa", "mero de ", "\u00f3", "bitos confirmados")
    if (prop_pop) {
      leg_y <- paste(leg_y, "por cem mil habitantes")
      df$var <- df$last_available_deaths/df$estimated_population_2019 * 100000
    }
  }
  leg_x <- "Data"
  # filtra os n estados
  df.max <- df[df$date == max(df$date), ]
  #select states after setting df$var and only have one code for plot

  if (is.null(estados) & !is.null(n)) {
  estados <- as.character(df.max$state[order(df.max$var, decreasing = TRUE)[1:n]])
  }
  df <- df[df$state %in% estados, ]
  state_plot <- df %>%
      ggplot() +
      aes(x = .data$date,
          y = .data$var,
          colour = reorder(.data$state, -.data$var)) +
      geom_line() +
      geom_point() +
      labs(y = leg_y, x = leg_x) +
      guides(color = guide_legend("UF")) +
      scale_x_date(date_breaks = "60 day",
                   date_labels = "%d/%b") +
      scale_color_viridis_d() +
      theme_minimal() +
      theme(legend.title = element_text(size = 7),
            legend.text = element_text(size = 7))
  print(state_plot)
}

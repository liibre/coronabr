#' Plot o número de casos (confirmados ou óbitos) por Estados com dados do Brasil.io
#'
#' @param df Data frame por estado formatado com a função `format_corona_br()`
#' @param tipo Variável a ser exibida no eixo y. Padrão `tipo = "casos"` para mostrar os casos confirmados. Use `tipo = "obitos"` para o gráfico com o número de óbitos
#' @param prop_pop Lógico. Exibir gráfico com número de casos proporcional à população? Padrão prop_pop = TRUE
#' @param n Inteiro. Número mínimo de estados para o gráfico
#'
#' @importFrom dplyr filter mutate glimpse
#' @importFrom stats reorder setNames
#' @import ggplot2
#' @importFrom rlang .data
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
                     n = 10) {

  # remove na
  df <- na.omit(df)
  df$state <- as.character(df$state)
  if (tipo == "casos") {
    df$var <- df$confirmed
    leg_y <- "Número de casos confirmados"
  } else {
    df$var <- df$deaths
    leg_y <- "Número de óbitos confirmados"
  }

  # filtra os n estados
  df.max <- df[df$date == max(df$date), ]
  estados <- as.character(df.max$state[order(df.max$var, decreasing = TRUE)[1:n]])
  df <- df[df$state %in% estados, ]

  if (tipo == "casos") {
    if (prop_pop) df$var <- df$confirmed_per_100k_inhabitants

    state_plot <- df %>%
      ggplot() +
      aes(x = date,
          y = var,
          colour = reorder(state, -var)) +
      geom_line() +
      geom_point() +
      labs(y = leg_y)
      guides(color = guide_legend("UF")) +
      scale_x_date(date_breaks = "15 day",
                   date_labels = "%d/%b") +
      scale_color_viridis_d() +
      theme_minimal() +
      theme(legend.title = element_text(size = 7),
            legend.text = element_text(size = 7))

  }

  if (tipo == "obitos") {

    state_plot <- df %>%
      ggplot() +
      aes(x = date,
          y = var,
          colour = reorder(state, -var)) +
      geom_line() +
      geom_point() +
      labs(y = leg_y) +
      guides(color = guide_legend("UF")) +
      scale_x_date(date_breaks = "15 day",
                   date_labels = "%d/%b") +
      scale_color_viridis_d() +
      theme_minimal() +
      theme(legend.title = element_text(size = 7),
            legend.text = element_text(size = 7))

  }

  print(state_plot)

}

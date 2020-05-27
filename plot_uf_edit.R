#' Plot o número de casos (confirmados ou óbitos) por Estados com dados do Brasil.io
#'
#' @param df Data frame por estado formatado com a função `format_corona_br()`
#' @param tipo Variável a ser exibida no eixo y. Padrão `tipo = "casos"` para mostrar os casos confirmados. Use `tipo = "obitos"` para o gráfico com o número de óbitos
#' @param prop_pop Lógico. Exibir gráfico com número de casos proporcional à população? Padrão prop_pop = TRUE
#' @param n Inteiro. Número mínimo de casos para comparação entre estados
#' @param dir Caractere. Nome do diretório onde salvar a animação. Usar apenas se anim = TRUE.

#' @importFrom dplyr filter mutate
#' @importFrom stats reorder setNames
#' @import ggplot2
#' @importFrom rlang 
#'
#' @return objeto ggplot
#'
#' @examples
#' \dontrun{
#' dados <- get_corona_br(by_uf = TRUE)
#' dados_format <- format_corona_br(df)
#' plot_uf(df = dados_format)
#' }
#' @export
#'
plot_uf <- function(df,
                    prop_pop = TRUE,
                    tipo = "casos",
                    n_casos = 1500,
                    n_obitos = 100) {

  # if (prop_pop == TRUE) {
  #   df <- df %>% dplyr::mutate(confirmed = confirmed_per_100k_inhabitants)
  # } else {
  #   df <- df
  # }

  glimpse(df)

  if (tipo == "casos") {

    state_plot <- df %>%
      filter(!is.na(state) & confirmed > n_casos) %>%
      ggplot() +
      aes(
        x = date,
        y = confirmed,
        colour = reorder(state, -confirmed)
      ) +
      geom_line() +
      geom_point() +
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
      filter(!is.na(state) & deaths > n_obitos) %>%
      ggplot() +
      aes(
        x = date,
        y = deaths,
        colour = reorder(state, -deaths)
      ) +
      geom_line() +
      geom_point() +
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

#' Plot o número de casos (confirmados ou mortes) por Estados com dados do Brasil.io
#'
#' @param df Data frame por estado formatado com a função `format_corona_br()`
#' @param tipo Variável a ser exibida no eixo y. Padrão `tipo = "casos"` para mostrar os casos confirmados. Use `tipo = mortes` para o gráfico com o número de mortes
#' @param prop_pop Lógico. Exibir gráfico com número de casos proporcional à população? Padrão prop_pop = TRUE
#' @param n Inteiro. Número mínimo de casos para comparação entre estados
#' @param dir Caractere. Nome do diretório onde salvar a animação. Usar apenas se anim = TRUE.

#' @importFrom dplyr filter mutate
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
                    n = 1500,
                    dir = "figs") {
  # definindo data_max para plotar apenas atualizacoes completas
  datas <-
    as.data.frame(
      table(df$date[df$confirmed > 0 & !is.na(df$state)]), stringsAsFactors = FALSE
    ) %>%
    setNames(c("x", "freq")) %>%
    mutate(x = as.Date(x))
  datas$lag <- datas$freq - dplyr::lag(datas$freq)
  if (datas$lag[which.max(datas$x)] < 0) {
    data_max <- max(datas$x, na.rm = TRUE) - 1
  } else {
    data_max <- max(datas$x, na.rm = TRUE)
  }
  # selecionando os estados para plotar
  states <- df$state[df$confirmed > n & df$date == data_max]
  # fonte
  legenda <- "fonte: https://brasil.io/dataset/covid19/caso"
  # plot basico
  if (prop_pop == TRUE) {
    df <- df %>% dplyr::mutate(confirmed = .data$confirmed_per_100k_inhabitants)
  } else {
    df <- df
  }

  state_plot <- df %>%
    dplyr::filter(.data$state %in% states & !is.na(.data$state)) %>%
    ggplot(aes(x = date, y = .data$confirmed, colour = .data$state)) +
    geom_line() +
    geom_point() +
    labs(title = paste0("Estados com mais de ", n, " casos"),
         fill = "UF",
         caption = legenda) +
    guides(color = guide_legend("UF")) +
    scale_x_date(date_breaks = "10 days",
                 date_labels = "%d/%m") +
    scale_color_viridis_d() +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 90),
          legend.title = element_text(size = 7),
          legend.text = element_text(size = 7))

  if (tipo == "casos") {
    state_plot <- state_plot %+%
      aes(x = .data$date, y = .data$deaths, colour = reorder(.data$state, -.data$confirmed)) +
      labs(y = paste0("N", "\u00fa", "meros de casos confirmados"),
           x = "Data")
  }
  if (tipo == "mortes") {
    state_plot <- state_plot %+%
      aes(x = .data$date, y = .data$deaths, colour = reorder(.data$state, -.data$deaths)) +
      labs(y = paste0("N", "\u00fa", "meros de mortes confirmadas"),
           x = "Data")

  }

  print(state_plot)

}

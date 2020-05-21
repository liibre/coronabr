#' Gráfico do número de casos de COVID-19 no Brasil para os dados do Ministério da Saúde
#'
#' Esta função plota o crescimento no número de casos no Brasil ao longo do tempo. Há duas opções de gráfico, veja o argumento `tipo` para mais detalhes.
#'
#' @param df Data frame contendo o resultado da busca de `get_corona_minsaude()`
#' @param log Lógico. Se quer manter a escala log no eixo y do gráfico. Padrão log = TRUE. Apenas para `tipo = "numero"`
#' @param tipo Caractere. Padrão `tipo = "numero"` para o número de casos ao longo do tempo. Usar `tipo = "aumento"` para plotar o aumento diário no número de casos
#'
#' @export
#'
#' @importFrom rlang .data
#' @importFrom plyr count
#'
plot_corona_minsaude <- function(df,
                                 log = TRUE,
                                 tipo = "numero") {
  # definindo data_max para plotar apenas atualizacoes completas
  datas <- plyr::count(df$date[df$casosAcumulado > 0 & !is.na(df$estado)])
  datas$lag <- datas$freq - dplyr::lag(datas$freq)
  if (datas$lag[which.max(datas$x)] < 0) {
    data_max <- max(datas$x, na.rm = TRUE) - 1
  } else {
    data_max <- max(datas$x, na.rm = TRUE)
  }
  # nomes dos eixos
  xlab <- "Data"
  ylab <- "Casos confirmados"
  legenda <- "fonte: https://covid.saude.gov.br"
  df <- df %>%
    dplyr::group_by(., .data$date) %>%
    dplyr::summarise_at(dplyr::vars(.data$casosAcumulado, .data$obitosAcumulado),
                        .funs = sum, na.rm = TRUE) %>%
    dplyr::filter(., .data$date <= data_max)
  # tipo = numero
  if (tipo == "numero") {
    if (log == TRUE) {
      df <- df %>% dplyr::mutate(casosAcumulado = log(.data$casosAcumulado))
      ylab <- paste(ylab, "(log)")
    }
    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$date,
                                          y = .data$casosAcumulado,
                                          color = "red")) +
      ggplot2::geom_line(alpha = .7) +
      ggplot2::geom_point(size = 2) +
      ggplot2::labs(x = xlab,
                    y = ylab,
                    title = "Casos confirmados de COVID-19 no Brasil",
                    caption = legenda) +
      ggplot2::scale_x_date(date_breaks = "1 day",
                            date_labels = "%d/%m") +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text.x = ggplot2::element_text(angle = 90),
                     legend.position = "none")
  }
  if (tipo == "aumento") {
    df$delta_cases <- df$casosAcumulado - dplyr::lag(df$casosAcumulado)
    # O.o tem valores negativos! por enquanto, deixei 0 nao bate com min saude
    df$delta_cases <- ifelse(df$delta_cases < 0 , 0, df$delta_cases)
    #df$diff_perc <- round(df$delta_cases/df$confirmed, 3) * 100
    #df$label <- paste(df$delta_cases, "%")
    p <- ggplot2::ggplot(df, ggplot2::aes(x = .data$date,
                                          y = .data$delta_cases,
                                          color = "red")) +
      #ggplot2::geom_bar(stat = "identity", alpha = .7, color = "red", fill = "red")
      ggplot2::geom_line(alpha = .7) +
      ggplot2::geom_point(size = 2) +
      ggplot2::scale_x_date(date_breaks = "1 day",
                            date_labels = "%d/%m") +
      # ggplot2::scale_y_continuous(limits = c(0, max(df$delta_cases, na.rm = TRUE) + 3),
      #                             expand = c(0, 0)) +
      # ggplot2::geom_text(ggplot2::aes(label = .data$label),
      #                    size = 2.5,
      #                    vjust = -0.5) +
      ggplot2::labs(x = xlab,
                    y = "Casos novos por dia",
                    title = "Aumento nos casos de COVID-19 confirmados",
                    caption = legenda) +
      ggplot2::theme_minimal() +
      ggplot2::theme(axis.text.x =  ggplot2::element_text(angle = 90),
                     legend.position = "none")
  }
  p
}

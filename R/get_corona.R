#' Extrai dados de corona vírus para o Brasil
#'
#' Esta função extrai os valores compilados pelo ministério da Saúde do Brasil (disponível em: 'http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil') e salva o resultado no disco.
#'
#' @param dir Diretório onde salvar o arquivo
#' @param filename Nome do arquivo
#'
#' @importFrom rvest html_text
#' @importFrom stringr str_split
#' @importFrom jsonlite fromJSON
#' @importFrom utils write.csv
#' @importFrom dplyr mutate mutate_if bind_rows
#' @importFrom rlang .data
#' @import magrittr
#' @import plyr
#'
#' @export
#'
get_corona <- function(dir = "output/",
                       filename = "corona_brasil"){
  rlang::.data #para usar vars no dplyr
  url <- 'http://plataforma.saude.gov.br/novocoronavirus/resources/scripts/database.js'
  # url
  message("Extraindo os dados ...")
  tryCatch(
    dados <- xml2::read_html(url) %>%
    rvest::html_text() %>%
    # gambiarra porque dava erro para ler o json direto
    url %>%
    gsub("var database=", "", .) %>%
    jsonlite::fromJSON(encoding = "UTF-8"),
    error = function(x) {}
    )
   if ( !exists("dados") ) {
     stop("Falha no download dos dados :( Site do Min. da saude fora do ar!")
  }
  # AQUI PRECISA ADICIONAR MSG DE ERRO SE O OBJETO DADOS NAO É CRIADO
  # extraindo so braSil
  br <- dados$brazil
  br$id_date <- 1:nrow(br)
  vals <- br$values %>%
    lapply(., dplyr::mutate_if, is.integer, as.character) %>%
    dplyr::bind_rows(., .id = "id_date")
  df <- merge(br[, c('date', 'id_date')],
              vals[, !names(vals) %in% c('comments', 'broadcast')],
              by = "id_date")
  df$date <-  as.Date(df$date, format = "%d/%m/%Y")
  new_df <- df %>%
    dplyr::group_by(.data$id_date, .data$date, .data$uid) %>%
    dplyr::mutate_at(dplyr::vars(-dplyr::group_cols()), as.numeric) %>%
    dplyr::summarize_at(dplyr::vars(-dplyr::group_cols()), dplyr::funs(sum(., na.rm = TRUE)))
  message(paste0("salvando ", filename, ".csv em ", dir))
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  utils::write.csv(new_df, paste0(dir, filename, ".csv"),
                   row.names = FALSE)
  return(new_df)
}

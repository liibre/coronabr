#' Extrai dados de corona vírus para o Brasil
#'
#' Esta função extrai os valores compilados pelo ministério da Saúde do Brasil (disponível em: 'http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil') e salva o resultado no disco.
#'
#' @param dir diretório onde salvar o arquivo
#' @param filename nome do arquivo
#'
#' @importFrom  rvest html_session
#' @importFrom rvest html_nodes
#' @importFrom httr timeout
#' @importFrom stringr str_split
#' @importFrom jsonlite fromJSON
#' @importFrom utils write.csv
#' @importFrom dplyr mutate_if
#' @importFrom dplyr bind_rows
#' @importFrom rlang .data
#' @import magrittr
#' @import plyr
#'
#' @export
#'
get_corona <- function(dir = "output/",
                       filename = "corona_brasil"){
  rlang::.data #precisa para usar vars no dplyr
  if (!dir.exists(dir)) {
    dir.create(dir)
  }
  # url
  message("Extraindo a url ...")
  url <- 'http://plataforma.saude.gov.br/novocoronavirus/#COVID-19-brazil'
  res <- rvest::html_session(url, httr::timeout(30)) # aqui precisa adicionar msg de erro se o site tiver out
  # para pegar a url verdadeira com os dados
  url2 <- rvest::html_nodes(res, "script") %>%
    magrittr::extract2(12) %>%
    as.character() %>%
    # para extrair so a url :facepalm:
    stringr::str_split(., '"') %>%
    unlist() %>%
    .[2]
  # lendo json para uma lista
  message("extraindo os dados ...")
  dados <- readLines(url2) %>%
    # gambiarra porque dava erro para ler o json direto
    gsub("var database=", "", .) %>%
    jsonlite::fromJSON()
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
  utils::write.csv(new_df, paste0(dir, filename, ".csv"),
                   row.names = FALSE)
  return(new_df)
}

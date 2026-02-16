#' Ler tabela do Excel via clipboard para Plackett Burman
#'
#' Copie a tabela do Excel incluindo o cabecalho e use esta funcao.
#'
#' @param sep Separador, padrao tab.
#' @return data.frame com colunas numericas.
#' @export
read_clipboard_dpb <- function(sep = "\t") {
  dados <- read.table("clipboard", header = TRUE, sep = sep)
  dados[] <- lapply(dados, as.numeric)
  dados
}

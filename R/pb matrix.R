#' Gerar matriz Plackett Burman com FrF2
#'
#' @param nruns Numero de ensaios, padrao 12.
#' @param nfactors Numero de fatores.
#' @param factor.names Nomes dos fatores.
#' @param randomize Se TRUE, randomiza a ordem.
#' @return Objeto de planejamento do FrF2.
#' @export
pb_matrix <- function(nruns = 12,
                      nfactors = 7,
                      factor.names = c("A","B","C","D","E","F","G"),
                      randomize = FALSE) {
  FrF2::pb(nruns = nruns,
           nfactors = nfactors,
           factor.names = factor.names,
           randomize = randomize)
}

#' Relatorio de triagem, ANOVA, efeitos e graficos
#'
#' Ajusta modelo linear com efeitos principais e gera:
#' ANOVA, coeficientes, R2, tabela de efeitos,
#' grafico compacto de efeitos principais e Pareto com limite critico.
#'
#' @param data data.frame com fatores e resposta.
#' @param response Nome da coluna resposta, exemplo "Rendimento".
#' @param factors Vetor com nomes dos fatores. Se NULL, usa todas as colunas exceto response.
#' @param alpha Nivel de significancia, padrao 0.05.
#' @param ylim Limites do eixo Y no grafico de efeitos principais. Se NULL, usa range automatico.
#' @param bar_col Cor das barras no Pareto.
#' @param pareto_type "t" para Pareto por |t|, "F" para Pareto por F calculado.
#' @param show_lenth Se TRUE, mostra LenthPlot (util para triagem sem replica).
#' @return Lista com modelo, anova, summary, efeitos, tcrit, Fcrit.
#' @export
dpb_report <- function(data,
                       response = "Rendimento",
                       factors = NULL,
                       alpha = 0.05,
                       ylim = NULL,
                       bar_col = "#4A90E2",
                       pareto_type = c("t", "F"),
                       show_lenth = FALSE) {

  pareto_type <- match.arg(pareto_type)

  if (!is.data.frame(data)) stop("data deve ser um data.frame.")
  if (!response %in% names(data)) stop("A resposta nao existe no data.frame.")

  if (is.null(factors)) {
    factors <- setdiff(names(data), response)
  } else {
    if (!all(factors %in% names(data))) stop("Alguns fatores nao existem em data.")
  }

  cols <- c(factors, response)
  for (nm in cols) {
    if (is.factor(data[[nm]])) data[[nm]] <- as.character(data[[nm]])
    data[[nm]] <- as.numeric(data[[nm]])
  }

  form <- stats::as.formula(paste(response, "~", paste(factors, collapse = "+")))
  modelo <- stats::lm(form, data = data)

  an <- stats::anova(modelo)
  sm <- summary(modelo)

  efeitos <- 2 * stats::coef(modelo)[-1]
  efeitos_tbl <- data.frame(Fator = names(efeitos),
                            Efeito = as.numeric(efeitos),
                            row.names = NULL)

  cat("\nANOVA\n")
  print(an)

  cat("\nCoeficientes, erro padrao, teste t e valor p\n")
  print(sm$coefficients)

  cat("\nMetricas do ajuste\n")
  cat("R2 =", sm$r.squared, "\n")
  cat("R2 ajustado =", sm$adj.r.squared, "\n")
  cat("Erro padrao residual =", sm$sigma, "\n")
  cat("GL residuais =", stats::df.residual(modelo), "\n")

  cat("\nEfeitos estimados (efeito = 2 * coeficiente)\n")
  print(efeitos_tbl)

  # Grafico de efeitos principais, compacto
  if (is.null(ylim)) {
    r <- range(data[[response]], na.rm = TRUE)
    ylim <- c(r[1], r[2])
  }

  media_geral <- mean(data[[response]], na.rm = TRUE)

  op <- graphics::par(mfrow = c(1, length(factors)),
                      mar = c(4, 2, 3, 1),
                      oma = c(0, 4, 0, 0))
  on.exit(graphics::par(op), add = TRUE)

  for (f in factors) {
    m_m1 <- mean(data[[response]][data[[f]] == -1], na.rm = TRUE)
    m_p1 <- mean(data[[response]][data[[f]] ==  1], na.rm = TRUE)

    graphics::plot(c(-1, 1), c(m_m1, m_p1),
                   type = "b",
                   xaxt = "n",
                   xlab = "",
                   ylab = "",
                   main = f,
                   ylim = ylim,
                   lwd = 2,
                   pch = 19)

    graphics::axis(1, at = c(-1, 1), labels = c(-1, 1))
    graphics::abline(h = media_geral, lty = 2)
  }

  graphics::mtext(response, side = 2, line = 2, outer = TRUE)
  graphics::title(main = "Grafico de efeitos principais, planejamento de triagem",
                  outer = TRUE, line = -1)

  # Criticos automaticos
  df_res <- stats::df.residual(modelo)
  tcrit <- stats::qt(1 - alpha/2, df = df_res)
  Fcrit <- stats::qf(1 - alpha, 1, df_res)

  # Pareto
  tab <- sm$coefficients
  tab <- tab[rownames(tab) != "(Intercept)", , drop = FALSE]

  if (pareto_type == "t") {
    val <- abs(tab[, "t value"])
    val <- sort(val, decreasing = TRUE)

    graphics::par(mfrow = c(1, 1))
    bp <- graphics::barplot(val,
                            horiz = TRUE,
                            las = 1,
                            col = bar_col,
                            border = NA,
                            xlab = "Efeitos padronizados (|t|)",
                            main = paste0("Pareto por |t|, t critico, alpha = ", alpha))

    graphics::abline(v = tcrit, lty = 2, col = "red", lwd = 2)
    graphics::text(tcrit, max(bp) + 0.6, labels = round(tcrit, 3), col = "red", pos = 3)

  } else {
    tvals <- tab[, "t value"]
    val <- (tvals^2)
    names(val) <- rownames(tab)
    val <- sort(val, decreasing = TRUE)

    graphics::par(mfrow = c(1, 1))
    bp <- graphics::barplot(val,
                            horiz = TRUE,
                            las = 1,
                            col = bar_col,
                            border = NA,
                            xlab = "F calculado (t^2)",
                            main = paste0("Pareto por F, F critico, alpha = ", alpha))

    graphics::abline(v = Fcrit, lty = 2, col = "red", lwd = 2)
    graphics::text(Fcrit, max(bp) + 0.6, labels = round(Fcrit, 3), col = "red", pos = 3)
  }

  if (isTRUE(show_lenth)) {
    BsMD::LenthPlot(modelo, main = "Triagem de efeitos, metodo de Lenth")
  }

  invisible(list(
    modelo = modelo,
    anova = an,
    summary = sm,
    efeitos = efeitos_tbl,
    tcrit = tcrit,
    Fcrit = Fcrit
  ))
}

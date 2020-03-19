#' Pipe operator
#'
#' See \code{magrittr::\link[magrittr:pipe]{\%>\%}} for details.
#'
#' @name %>%
#' @rdname pipe
#' @keywords internal
#' @export
#' @importFrom magrittr %>%
#' @usage lhs \%>\% rhs
NULL

globalVariables(c(
  "cases", "confirmado", "deads", "deaths", "id_date", "refuses",
  "suspects", "uid", "values"
))

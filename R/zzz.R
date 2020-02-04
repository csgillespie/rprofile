.rprofile = new.env()

#' Retrieve the hidden environment
#'
#' Returns the hidden environment that contains the hidden functions.
#' @param load_last_error Default TRUE
#' @param load_last_trace Default TRUE
#' @param load_lsos  Default TRUE
#' @param load_cp  Default TRUE
#' @param load_op  Default TRUE
#' @param load_library  Default TRUE
#' @param load_inf_mr Default TRUE. Create shortcut to \code{xaringan::inf_mr}.
#' @export
set_functions = function(load_last_error = TRUE,
                         load_last_trace = TRUE,
                         load_lsos = TRUE,
                         load_cp = TRUE,
                         load_op = TRUE,
                         load_library = TRUE,
                         load_inf_mr = TRUE) {
  if (isTRUE(load_last_error)) .rprofile$last_error = rlang::last_error
  if (isTRUE(load_last_trace)) .rprofile$last_trace = rlang::last_trace
  if (isTRUE(load_lsos)) .rprofile$lsos = lsos
  if (isTRUE(load_op)) .rprofile$op = op
  if (isTRUE(load_cp)) .rprofile$cp = cp
  if (isTRUE(load_library)) .rprofile$library = autoinst

  if (isTRUE(load_inf_mr) && requireNamespace("xaringan", quietly = TRUE)) {
    .rprofile$inf_mr = xaringan::inf_mr
  }
  return(.rprofile)
}

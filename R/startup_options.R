#' @title Set Nice Startup Options
#'
#' Sets nicer options. All arguments are passed to the \code{options} function.
#' This function also sets \code{ipck = TRUE} in \code{rc.settings}.
#' @param digits Default \code{4}
#' @param show.signif.stars Default \code{FALSE}
#' @param useFancyQuotes Default \code{FALSE}
#' @param fix_width Default \code{88}
#' @param Ncpus Default number of CPUs - 1. Used for parallel pkg installs.
#' @param continue Default blank space (remove the defaut +)
#' @param max.print Default 100 to avoid blow up
#' @param servr.daemon Default \code{TRUE}.  For xaringan presentations
#' @param max Default \code{10}. For List printing
#' @param mc.cores Default number of CPUs - 1. Used for parallel computing
#' @param error Default \code{rlang}. If \code{rlang} is installed, then error = rlang::entrace.
#' @param ... Other arguments passed to \code{options}.
#' @export
set_startup_options = function(digits = 4,
                               show.signif.stars = FALSE, #nolint
                               useFancyQuotes = FALSE, #nolint
                               fix_width = 88,
                               Ncpus = max(1L, parallel::detectCores() - 1L),
                               continue = " ",
                               max.print = 100, # Avoid blow up
                               servr.daemon = TRUE, # For xaringan presentations,
                               max = 10L, # List printing
                               mc.cores = max(1L, parallel::detectCores() - 1L),
                               error = "rlang",
                               ...) {

  options(digits = digits,
          show.signif.stars = show.signif.stars, #nolint
          useFancyQuotes = useFancyQuotes, #nolint
          fix_width = fix_width,
          Ncpus = Ncpus,
          continue = continue,
          max.print = max.print, # Avoid blow up
          servr.daemon = servr.daemon, # For xaringan presentations,
          max = max, # List printing
          mc.cores = mc.cores,
          ...)
  if (error == "rlang") {
    if (requireNamespace("rlang", quietly = TRUE)) options(error = rlang::entrace)
  } else {
    options(error = error)
  }
  # enable autocompletions for package names in
  # `require()`, `library()`
  utils::rc.settings(ipck = TRUE)
}

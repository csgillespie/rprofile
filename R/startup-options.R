#' @title Set Nice Startup Options
#'
#' Sets nicer options. All arguments are passed to the \code{options} function.
#' This function also sets \code{ipck = TRUE} in \code{rc.settings}.
#' @param digits Default \code{4}
#' @param show.signif.stars Default \code{FALSE}
#' @param useFancyQuotes Default \code{FALSE}
#' @param width Default \code{100}
#' @param Ncpus Default number of CPUs - 1. Used for parallel pkg installs.
#' @param continue Default blank space (remove the default +)
#' @param max.print Default 100 to avoid blow up
#' @param servr.daemon Default \code{TRUE}.  For xaringan presentations
#' @param max Default \code{10}. For List printing
#' @param mc.cores Default number of CPUs - 1. Used for parallel computing
#' @param error Default \code{rlang}. If \code{rlang} is installed, then error = rlang::entrace.
#' @param menu.graphics Default \code{FALSE}. Logical: should graphical menus be used if available?
#' @param warnPartialMatchArgs Default \code{TRUE}. Warn if using partial arguments.
#' @param scipen Default \code{999}. Always print out full numbers, i.e. not 1e2
#' @param HTTPUserAgent Used by RStudio Package Manager (RSPM).
#' @param download.file.extra Used by RSPM for curl/wget installs, e.g. Rscript.
#' @param ... Other arguments passed to \code{options}.
#' @export
set_startup_options = function(digits = 4L,
                               show.signif.stars = FALSE, #nolint
                               useFancyQuotes = FALSE, #nolint
                               width = 88L,
                               Ncpus = max(1L, parallel::detectCores() - 1L),
                               continue = " ",
                               max.print = 100L, # Avoid blow up
                               servr.daemon = TRUE, # For xaringan presentations,
                               max = 10L, # List printing
                               mc.cores = max(1L, parallel::detectCores() - 1L),
                               error = "rlang",
                               menu.graphics = FALSE,
                               warnPartialMatchArgs = TRUE, # nolint
                               scipen = 999L,               # nolint
                               HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
                                                       paste(getRversion(),
                                                             R.version$platform,
                                                             R.version$arch,
                                                             R.version$os)),
                               download.file.extra = sprintf("--header \"User-Agent: R (%s)\"",
                                                             paste(getRversion(),
                                                                   R.version$platform,
                                                                   R.version$arch,
                                                                   R.version$os)),
                               ...) {

  options(digits = digits,
          show.signif.stars = show.signif.stars, #nolint
          useFancyQuotes = useFancyQuotes, #nolint
          width = width,
          Ncpus = Ncpus,
          continue = continue,
          max.print = max.print, # Avoid blow up
          servr.daemon = servr.daemon, # For xaringan presentations,
          max = max, # List printing
          mc.cores = mc.cores,
          warnPartialMatchArgs = warnPartialMatchArgs,
          scipen = scipen,
          HTTPUserAgent = HTTPUserAgent,
          download.file.extra = download.file.extra,
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

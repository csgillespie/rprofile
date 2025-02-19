#' @title Set Nice Startup Options
#'
#' @description Sets nicer options. All arguments are passed to the \code{options} function.
#' This function also sets \code{ipck = TRUE} in \code{rc.settings}.
#' @param digits Default \code{4}
#' @param show.signif.stars Default \code{FALSE}
#' @param check.bounds logical, defaulting to FALSE. If true, a warning is produced whenever a
#' vector (atomic or list) is extended, by something like x <- 1:3; x[5] <- 6.
#' @param useFancyQuotes Default \code{FALSE}
#' @param setWidthOnResize If set and TRUE, R run in a terminal using a recent readline
#' library will set the width option when the terminal is resized.
#' @param width Default cli::console_width() + 13L. See details.
#' @param Ncpus Default number of CPUs - 1. Used for parallel pkg installs.
#' @param continue Default blank space (remove the default +)
#' @param max.print Default 100 to avoid blow up
#' @param servr.daemon Default \code{TRUE}.  For xaringan presentations
#' @param max Default \code{10}. For List printing
#' @param mc.cores Default number of CPUs - 1. Used for parallel computing
#' @param error Default \code{rlang}. If \code{rlang} is installed, then error = rlang::entrace.
#' @param menu.graphics Default \code{FALSE}. Logical: should graphical menus be used if available?
#' @param warnPartialMatchArgs,warnPartialMatchAttr,warnPartialMatchDollar Default \code{TRUE}.
#' Warn if using partial arguments.
#' @param scipen Default \code{999}. Always print out full numbers, i.e. not 1e2
#' @param HTTPUserAgent Used by RStudio Package Manager (RSPM).
#' @param download.file.extra Used by RSPM for curl/wget installs, e.g. Rscript.
#' @param show.error.locations Show error locations for sourcing
#' @param ... Other arguments passed to \code{options}.
#' @details The \code{width} is only used in an R terminal (not RStudio). However,
#' fancy prompts that involve colours (such as grey), mean that the column count is off
#' as grey is \code{grey()(cli::symbol$pointer)} is translated to a 17 character
#' Unicode string. My slightly hacky solution is to add a line break in the
#' prompt, than add an additional 17 characters to the width to pad out the width.
#' @export
set_startup_options = function(
    digits = 4L,
    show.signif.stars = FALSE, #nolint
    useFancyQuotes = FALSE, #nolint
    width = cli::console_width(),
    Ncpus = max(1L, parallel::detectCores() - 1L), #nolint
    continue = " ",
    max.print = 100L, # Avoid blow up
    servr.daemon = TRUE, # For xaringan presentations, #nolint
    max = 10L, # List printing
    mc.cores = max(1L, parallel::detectCores() - 1L), #nolint
    warnPartialMatchArgs = TRUE, # nolint
    warnPartialMatchDollar = TRUE,
    warnPartialMatchAttr = TRUE, # nolint
    scipen = 999L,               # nolint
    HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(),
                            paste(getRversion(),
                                  R.version$platform,
                                  R.version$arch,
                                  R.version$os)),
    download.file.extra = sprintf("--header \"User-Agent: R (%s)\"",
                                  paste(getRversion(), R.version$platform,
                                        R.version$arch, R.version$os)),

    setWidthOnResize = TRUE,
    show.error.locations = TRUE, #nolint
    check.bounds = FALSE,
    menu.graphics = FALSE,
    error = "rlang",
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
          warnPartialMatchDollar = warnPartialMatchDollar,
          warnPartialMatchAttr = warnPartialMatchAttr,
          scipen = scipen,
          HTTPUserAgent = HTTPUserAgent,
          download.file.extra = download.file.extra,
          setWidthOnResize = setWidthOnResize,
          show.error.locations = show.error.locations,
          check.bounds = check.bounds,
          menu.graphics = menu.graphics,
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

#' @export
set_startup_options = function(digits = 4,
                               show.signif.stars = FALSE, #nolint
                               useFancyQuotes = FALSE, #nolint
                               fix_width = 88,
                               Ncpus = 6L,
                               continue = " ",
                               max.print = 100, # Avoid blow up
                               servr.daemon = TRUE, # For xaringan presentations,
                               max = 10L, # List printing
                               mc.cores = 6L) {

  options(digits = digits,
          show.signif.stars = show.signif.stars, #nolint
          useFancyQuotes = useFancyQuotes, #nolint
          fix_width = fix_width,
          Ncpus = Ncpus,
          continue = continue,
          max.print = max.print, # Avoid blow up
          servr.daemon = servr.daemon, # For xaringan presentations,
          max = max, # List printing
          mc.cores = mc.cores)
  if (requireNamespace("rlang", quietly = TRUE)) options(error = rlang::entrace)
  # enable autocompletions for package names in
  # `require()`, `library()`
  utils::rc.settings(ipck = TRUE)
}
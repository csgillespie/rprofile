#' @export
set_repos = function(repos = c(CRAN = "https://cran.rstudio.com/")) {

  r = getOption("repos")
  for (n in names(repos)) {
    r[n] = repos[n]
  }
  options(repos = r)
}
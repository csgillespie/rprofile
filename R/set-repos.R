#' @title Set R repositories
#' A simple function for setting R repositories.
#' @param CRAN Default is RStudio's CRAN repo
#' @param ... Other repositories
#' @examples
#' \dontrun{
#' set_repos(repoX = "https://example.com")
#' }
#' @export
set_repos = function(CRAN = "https://cran.rstudio.com/", ...) {
  repos = c(CRAN = CRAN, unlist(list(...)))
  r = getOption("repos")
  for (n in names(repos)) {
    r[n] = repos[n]
  }
  options(repos = r)
}

#' Detects R terminal
#'
#' Return \code{TRUE} is terminal. But \code{FALSE} if the RStudio console.
#' The RStudio console doesn't require as much customisation as a standard console since
#' it is already pretty. But it does place limits on the prompt options (single line only).
#' @export
is_terminal = function() {
  Sys.getenv("RSTUDIO") != 1 ||
    (Sys.getenv("RSTUDIO") == "1" &&
       nzchar(Sys.getenv("RSTUDIO_TERM")))
}

#' @param rdoc Should we load the rdoc package
#' @param colorout Should we load the colorout package
#' @param prettycode Should we load the prettycode package
#' @rdname is_terminal
#' @export
set_terminal = function(rdoc = TRUE, colorout = TRUE, prettycode = TRUE) {
  prompt::set_prompt(prompt::prompt_fancy)
  if (isTRUE(prettycode)) prettycode::prettycode()
  if (isTRUE(rdoc)) {
    base::library("utils") # Needed for rdoc`?` to take precedence
    rdoc::use_rdoc()
  }

  if (isTRUE(colorout) && requireNamespace("colorout", quietly = TRUE)) {
      base::library("colorout")
  }
}

#' @rdname is_terminal
#' @export
set_rstudio = function(prettycode = TRUE) {
  if (isTRUE(prettycode)) prettycode::prettycode()
  prompt::set_prompt(rstudio_prompt)
}

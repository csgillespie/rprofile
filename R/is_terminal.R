#' @export
is_terminal = function() {
  Sys.getenv("RSTUDIO") != 1 ||
    (Sys.getenv("RSTUDIO") == "1" &&
       nzchar(Sys.getenv("RSTUDIO_TERM")))
}

#' @export
set_terminal = function() {
  prompt::set_prompt(prompt::prompt_fancy)
  prettycode::prettycode()
  base::library("utils") # Needed for rdoc`?` to take precedence
  rdoc::use_rdoc()
  base::library("colorout")
}

#' @export
set_rstudio = function() {
  prettycode::prettycode()
  prompt::set_prompt(rstudio_prompt)
}
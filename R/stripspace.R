# Uses git stripspace to clean files.
# Not particuraly elegant code. But a quick first pass to see if I like it
stripspace = function() {
  fnames = list.files(pattern = "\\.R$|\\.qmd$|\\.Rmd$|\\.md$", full.names = TRUE, recursive = TRUE)
  tmp = tempfile()
  for (fname in fnames) {
    cli::cli_alert("Updating {fname}")
    system2("git", c("stripspace", "<", fname, ">", tmp))
    system2("cat", c(tmp, ">", fname))
  }
  return(invisible(NULL))
}

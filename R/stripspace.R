# Uses git stripspace to clean files.
# Not particularly elegant code. But a quick first pass to see if I like it
stripspace = function() {
  fnames = list.files(
    pattern = "\\.R$|\\.qmd$|\\.Rmd$|\\.md$",
    full.names = TRUE,
    recursive = TRUE
  )
  tmp = tempfile()
  for (fname in fnames) {
    hash1 = rlang::hash_file(fname)
    system2("git", c("stripspace", "<", fname, ">", tmp))
    hash2 = rlang::hash_file(tmp)
    if (hash1 != hash2) {
      cli::cli_alert("Updating {fname}")
      system2("cat", c(tmp, ">", fname))
    }
  }
  invisible(NULL)
}

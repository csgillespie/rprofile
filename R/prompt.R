display_memuse = function() {
  current = memuse::Sys.procmem()[[1]]
  if (memuse::mu.size(current, FALSE) < 1e9) return("")
  size = memuse::mu.size(current)
  unit = memuse::mu.unit(current)
  paste0(round(size, 1), " ", unit, " ")
}

# Take from prompt
grey = function() {
  crayon::make_style("grey70")
}

rprofile_prompt = function(expr, value, ok, visible) {
  status = if (ok) crayon::green(cli::symbol$tick)
  else crayon::red(cli::symbol$cross)

  mem = display_memuse()
  gstatus = try(gert::git_status(), silent = TRUE)
  is_git = !inherits(gstatus, "try-error")
  if (all(is_git)) {
    branch_name = stringr::str_trunc(prompt::git_branch(), 15)
    git = paste0("[",
                 branch_name,
                 prompt::git_dirty(),
                 prompt::git_arrows(),
                 "]")
  } else {
    git = ""
  }

  paste0(status, " ",
         grey()(mem),
         #       crayon::blue(pkg))
         grey()(git),
         ifelse(is_terminal(), "\n", ""), # See options details for info
         grey()(cli::symbol$pointer), " ")
}

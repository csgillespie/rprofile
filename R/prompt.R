#' @import memuse
display_memuse = function () {
  current = memuse::Sys.procmem()[[1]]
  if (memuse::mu.size(current, FALSE) < 1e9) return("")
  size = memuse::mu.size(current)
  unit = memuse::mu.unit(current)
  paste0(round(size, 1), " ", unit, " ")
}

# Take from prompt
grey = function () {
  crayon::make_style("grey70")
}

#' @import crayon
#' @import prompt
#' @import clisymbols
#' @importFrom gert git_status
#' @export
rstudio_prompt = function (expr, value, ok, visible) {
  status = if (ok) crayon::green(clisymbols::symbol$tick)
  else crayon::red(clisymbols::symbol$cross)

  mem = display_memuse()
  status = try(gert::git_status(), silent = TRUE)
  is_git = class(status) != "try_error"
  if (all(is_git)) {
    git = paste0("[",
                 prompt::git_branch(),
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
         grey()(clisymbols::symbol$pointer), " ")
}

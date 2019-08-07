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
#' @export
rstudio_prompt = function (expr, value, ok, visible) {
  status = if (ok) crayon::green(clisymbols::symbol$tick)
  else crayon::red(clisymbols::symbol$cross)

  mem = display_memuse()

  git = prompt:::git_info()
  if (nchar(git) > 0) git = paste0("[", git, "]")
  paste0(status, " ",
         grey()(mem),
         #       crayon::blue(pkg))
         grey()(git),
         grey()(clisymbols::symbol$pointer), " ")
}

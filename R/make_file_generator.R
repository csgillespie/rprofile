# Add new make command.
# Use 12345list as this should be unique
# nolint start
get_list_str = function()  {
  c("rprofile-list:",
    "\t@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ \"^[#.]\") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'")
}
# nolint end

# Copy current Makefile to tmp and append list line
create_tmp_makefile = function(makefile_loc) {
  tmp_file = tempfile()
  tmp_make = readLines(makefile_loc, warn = FALSE)
  tmp_make = c(tmp_make, get_list_str())
  f = file(tmp_file, "w")
  on.exit(close(f))
  write(tmp_make, f)
  tmp_file
}

make_fun_factory = function(target) {
  function() system2("make", target)
}

#' @title Generate make functions
#'
#' Parses Makefile and automatically creates make_* functions
#' @param path Location of Makefile
#' @export
create_make_functions = function(path = ".") {

  makefile_loc = file.path(path, "Makefile")
  if (!file.exists(makefile_loc)) return(invisible(NULL))

  tmp_make = create_tmp_makefile(makefile_loc)
  make_list = system2("make", args = c("-f", tmp_make, "rprofile-list"), stdout = TRUE)

  # Add basic make to list
  make_list = c("", make_list)
  # Create function names
  make_names = paste0("make_", make_list)
  make_names[1] = "make"
  # Create functions
  l = lapply(make_list, make_fun_factory)
  names(l) = make_names
  message(make_names)
  list2env(l, .rprofile)
}

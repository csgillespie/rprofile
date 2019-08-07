# Add new make command.
# Use 12345list as this should be unique
# nolint start
get_list_str = function()  {
  c("rprofile-list:",
    "\t@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ \"^[#.]\") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$'")
}
# nolint end

# Copy current Makefile to tmp and append list line
create_tmp_makefile = function() {
  tmp_file = tempfile()
  tmp_make = readLines("Makefile", warn = FALSE)
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
#' @export
create_make_functions = function() {
  if (!file.exists("Makefile")) return(invisible(NULL))

  tmp_make = create_tmp_makefile()
  make_list = system2("make", args = c("-f", tmp_make, "rprofile-list"), stdout = TRUE)

  # Add basic make to list
  make_list = c("make", make_list)
  # Create function names
  make_names = paste0("make_", make_list)
  # Create functions
  l = lapply(make_list, make_fun_factory)
  names(l) = make_names
  list2env(l, .rprofile)
}

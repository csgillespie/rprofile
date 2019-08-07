.rprofile = new.env()
.rprofile$last_error = rlang::last_error
.rprofile$last_trace = rlang::last_trace
.rprofile$lsos = lsos


## RStudio functions
.rprofile$op = op
.rprofile$cp = cp

## Overwrite library
.rprofile$library = autoinst

#' @export
get_env = function() .rprofile

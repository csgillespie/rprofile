#' Compare R files with test files
#'
#' testthat has the naming convention of test-filename.R
#' This is a simple function that determines if any files
#' don't follow that convention.
#' It's meant to be a guide, not a perfect solution
test_checker = function() {
  r_files = list.files("R/", pattern = "*.R")
  test_files = list.files("tests/testthat/", pattern = "*.R")
  test_files = gsub("test-", "", test_files)

  test_files[!test_files %in% c(r_files, "setup.R")]
}

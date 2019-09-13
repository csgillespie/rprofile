test_that("Set Repos", {
  context("Repos")
  r = getOption("repos")
  set_repos(rprofile_test1 = "example.com", rprofile_test2 = "example.com")
  expect_equal(length(getOption("repos")) - length(r), 2)
  options(repos = r)
})

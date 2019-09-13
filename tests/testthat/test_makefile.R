test_that("Makefile", {
  context("Makefile")
  expect_true(file.exists("Makefile"))
  create_make_functions()
  r = .rprofile
  expect_equal(length(ls(envir = r)), 3)
  expect_equal(r$make(), 0)
  expect_equal(r$make_default(), 0)
  expect_equal(r$make_clean(), 0)

  expect_null(create_make_functions("missing-makefile"))
})

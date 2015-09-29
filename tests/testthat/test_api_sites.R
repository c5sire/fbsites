context("Sites")

tbl_new <- new_site_table()
tbl_get <- get_site_table()

test_that("Dummy table is created.", {
  expect_true(is.data.frame(tbl_new), TRUE)
  expect_true(is.data.frame(tbl_get), TRUE)
})

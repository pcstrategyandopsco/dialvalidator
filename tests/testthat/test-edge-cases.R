test_that("NA input handled", {
  expect_false(phone_valid(NA_character_))
  expect_true(is.na(phone_format(NA_character_)))
  expect_true(is.na(phone_type(NA_character_)))
  expect_true(is.na(phone_country(NA_character_)))
})
test_that("empty string handled", {
  expect_false(phone_valid(""))
  expect_true(is.na(phone_format("")))
})

test_that("NULL input handled", {
  result <- phone_parse(character(0))
  expect_length(result, 0)
})

test_that("very long number is invalid", {
  long_num <- paste0("+64", paste(rep("1", 20), collapse = ""))
  expect_false(phone_valid(long_num))
})

test_that("too short number is invalid", {
  expect_false(phone_valid("+641"))
  expect_false(phone_valid("+6421"))
})

test_that("all zeros is invalid", {
  expect_false(phone_valid("+640000000"))
})

test_that("phone_info returns data frame", {
  result <- phone_info("+64211234567")
  expect_s3_class(result, "data.frame")
  expect_equal(nrow(result), 1)
  expect_named(result, c("raw", "e164", "national", "international",
                          "region", "country_code", "type", "valid"),
               ignore.order = TRUE)
  expect_equal(result$e164, "+64211234567")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
})

test_that("phone_info with multiple numbers", {
  result <- phone_info(c("+64211234567", "+12125551234", "invalid"))
  expect_equal(nrow(result), 3)
  expect_equal(result$valid, c(TRUE, TRUE, FALSE))
  expect_true(is.na(result$e164[3]))
})

test_that("numbers with special characters parsed correctly", {
  # Parentheses, dashes, dots, spaces
  expect_true(phone_valid("+64-21-123-4567"))
  expect_true(phone_valid("+64.21.123.4567"))
  expect_true(phone_valid("+64 21 123 4567"))
})

test_that("number with only country code is invalid", {
  expect_false(phone_valid("+64"))
  expect_false(phone_valid("+1"))
})

test_that("IDD prefix 00 is stripped and number parsed internationally", {
  result <- phone_parse("006421303960", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "21303960")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
  expect_equal(phone_format("006421303960", default_region = "NZ"), "+6421303960")
})

test_that("IDD prefix 0161 is stripped and number parsed internationally", {
  # NZ international_prefix is "0(?:0|161)", so 0161 should also work
  result <- phone_parse("016112125551234", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "1")
  expect_equal(result$national_number, "2125551234")
  expect_equal(result$region, "US")
  expect_true(result$valid)
})

test_that("bare country code 64 detected for NZ number", {
  result <- phone_parse("64272306822", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "272306822")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
  expect_equal(phone_format("64272306822", default_region = "NZ"), "+64272306822")
})

test_that("normal national NZ number still works after IDD/bare changes", {
  result <- phone_parse("0211234567", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "211234567")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
  expect_equal(phone_format("0211234567", default_region = "NZ"), "+64211234567")
})

test_that("number legitimately starting with country code digits is not wrongly stripped", {
  # A valid NZ national number that happens to start with '6' should not be
  # misinterpreted as a bare country code. E.g. 06 area code landlines.
  result <- phone_parse("063456789", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "63456789")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
})

test_that("parenthesized country code with + is parsed as international", {
  # (+64) is a common way to denote country code in brackets
  result <- phone_parse("(+64) 211234567", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "211234567")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)
})

test_that("bare country code with national prefix is handled", {
  # (64) 0210246354 — CC in parens, then national prefix 0 retained
  result <- phone_parse("(64) 0210246354", default_region = "NZ")[[1]]
  expect_equal(result$country_code, "64")
  expect_equal(result$national_number, "210246354")
  expect_equal(result$region, "NZ")
  expect_true(result$valid)

  # 64095341983 — bare CC 64 + 09 area code landline with national prefix
  result2 <- phone_parse("64095341983", default_region = "NZ")[[1]]
  expect_equal(result2$country_code, "64")
  expect_equal(result2$national_number, "95341983")
  expect_equal(result2$region, "NZ")
  expect_true(result2$valid)
})

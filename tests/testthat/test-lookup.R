# --- Carrier ---

test_that("phone_carrier returns Optus for +61412345678", {
  expect_equal(phone_carrier("+61412345678"), "Optus")
})

test_that("phone_carrier returns Optus for AU national format", {
  expect_equal(phone_carrier("0412345678", default_region = "AU"), "Optus")
})

test_that("phone_carrier returns Optus for bare international AU", {
  expect_equal(phone_carrier("+61412987654"), "Optus")
})

test_that("phone_carrier returns NA for US fixed line", {
  expect_true(is.na(phone_carrier("+12015550123")))
})

test_that("phone_carrier returns NA for NZ landline", {
  expect_true(is.na(phone_carrier("+6495341983")))
})

test_that("phone_carrier returns NA for AU fixed line", {
  expect_true(is.na(phone_carrier("0398811234", default_region = "AU")))
})

# --- Geocoding ---

test_that("phone_geocode returns New Jersey for +12015550123", {
  expect_equal(phone_geocode("+12015550123"), "New Jersey")
})

test_that("phone_geocode returns Melbourne for AU fixed line", {
  expect_equal(phone_geocode("0398811234", default_region = "AU"), "Melbourne")
})

test_that("phone_geocode returns location for NZ landline", {
  result <- phone_geocode("+6495341983")
  expect_true(!is.na(result))
  expect_true(nzchar(result))
})

test_that("phone_geocode returns NA for AU mobile", {
  expect_true(is.na(phone_geocode("+61412345678")))
})

test_that("phone_geocode returns NA for NZ mobile", {
  expect_true(is.na(phone_geocode("+64211234567")))
})

# --- Timezone ---

test_that("phone_timezone returns Pacific/Auckland for NZ number", {
  expect_equal(phone_timezone("+64211234567"), "Pacific/Auckland")
})

test_that("phone_timezone returns America/New_York for US NJ number", {
  expect_equal(phone_timezone("+12015550123"), "America/New_York")
})

test_that("phone_timezone returns America/New_York for US NYC number", {
  expect_equal(phone_timezone("+12125551234"), "America/New_York")
})

test_that("phone_timezone returns Australia/Sydney for AU mobile", {
  expect_equal(phone_timezone("+61412345678"), "Australia/Sydney")
})

test_that("phone_timezone returns Australia/Sydney for AU fixed line", {
  expect_equal(phone_timezone("+61398811234"), "Australia/Sydney")
})

test_that("phone_timezones returns list with correct timezone", {
  result <- phone_timezones("+64211234567")
  expect_type(result, "list")
  expect_true("Pacific/Auckland" %in% result[[1]])
})

# --- Edge cases (aligned with dialr) ---

test_that("single digit '0' returns NA for all lookups", {
  expect_true(is.na(phone_carrier("0")))
  expect_true(is.na(phone_geocode("0")))
  expect_true(is.na(phone_timezone("0")))
})

test_that("short number '1234' returns NA for all lookups", {
  expect_true(is.na(phone_carrier("1234")))
  expect_true(is.na(phone_geocode("1234")))
  expect_true(is.na(phone_timezone("1234")))
})

test_that("NA input returns NA for all lookup functions", {
  expect_true(is.na(phone_carrier(NA_character_)))
  expect_true(is.na(phone_geocode(NA_character_)))
  expect_true(is.na(phone_timezone(NA_character_)))
  expect_true(is.na(phone_timezones(NA_character_)[[1]]))
})

test_that("invalid input returns NA for all lookup functions", {
  expect_true(is.na(phone_carrier("invalid")))
  expect_true(is.na(phone_geocode("invalid")))
  expect_true(is.na(phone_timezone("invalid")))
})

# --- Vectorised ---

test_that("vectorised carrier: mobile gets carrier, fixed line gets NA", {
  result <- phone_carrier(c("+61412345678", "+6495341983"))
  expect_length(result, 2)
  expect_equal(result[1], "Optus")
  expect_true(is.na(result[2]))
})

test_that("vectorised geocode: fixed line gets location, mobile gets NA", {
  result <- phone_geocode(c("+12015550123", "+61412345678"))
  expect_length(result, 2)
  expect_equal(result[1], "New Jersey")
  expect_true(is.na(result[2]))
})

test_that("vectorised timezone across countries", {
  result <- phone_timezone(c("+64211234567", "+12125551234", "+61412345678"))
  expect_length(result, 3)
  expect_equal(result[1], "Pacific/Auckland")
  expect_equal(result[2], "America/New_York")
  expect_equal(result[3], "Australia/Sydney")
})

test_that("vectorised timezones returns list", {
  result <- phone_timezones(c("+64211234567", "+12015550123"))
  expect_type(result, "list")
  expect_length(result, 2)
  expect_true("Pacific/Auckland" %in% result[[1]])
  expect_true("America/New_York" %in% result[[2]])
})

# --- default_region ---

test_that("phone_geocode with default_region", {
  expect_equal(phone_geocode("0398811234", default_region = "AU"), "Melbourne")
})

test_that("phone_timezone with default_region", {
  expect_equal(phone_timezone("0211234567", default_region = "NZ"), "Pacific/Auckland")
})

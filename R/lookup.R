#' Phone Number Lookups
#'
#' @description
#' Carrier, geocoding, and timezone lookups using bundled libphonenumber data.
#' Results are determined by longest-prefix matching against E164 digits.
#'
#' @name lookup
NULL

#' Look up the carrier for a phone number
#'
#' Returns the carrier name (e.g., "O2", "Vodafone") associated with a mobile
#' number prefix. Landline numbers typically have no carrier data and return
#' `NA`.
#'
#' @param number Character vector of phone numbers (E164 or national format).
#' @param default_region Default ISO 3166-1 alpha-2 region code for parsing
#'   national-format numbers (e.g., `"NZ"`, `"US"`).
#'
#' @return Character vector of carrier names, or `NA_character_` where no
#'   carrier data is available.
#'
#' @examples
#' phone_carrier("+61412345678")
#' phone_carrier("0412345678", default_region = "AU")
#'
#' @export
phone_carrier <- function(number, default_region = NULL) {
  ensure_metadata()
  ensure_lookup("carrier")
  parsed <- phone_parse(number, default_region = default_region)
  vapply(parsed, function(p) {
    if (is.na(p$country_code) || is.na(p$national_number)) return(NA_character_)
    e164 <- paste0(p$country_code, p$national_number)
    result <- longest_prefix_match(e164, the$carrier)
    if (is.na(result) || !nzchar(result)) NA_character_ else result
  }, character(1), USE.NAMES = FALSE)
}

#' Look up the geographic location for a phone number
#'
#' Returns the geographic description (e.g., "Leeds", "Auckland") associated
#' with a phone number prefix. Mobile numbers typically have no geocoding
#' data and return `NA`.
#'
#' @inheritParams phone_carrier
#'
#' @return Character vector of location descriptions, or `NA_character_` where
#'   no geocoding data is available.
#'
#' @examples
#' phone_geocode("+12125551234")
#' phone_geocode("+442071234567")
#'
#' @export
phone_geocode <- function(number, default_region = NULL) {
  ensure_metadata()
  ensure_lookup("geocoding")
  parsed <- phone_parse(number, default_region = default_region)
  vapply(parsed, function(p) {
    if (is.na(p$country_code) || is.na(p$national_number)) return(NA_character_)
    e164 <- paste0(p$country_code, p$national_number)
    result <- longest_prefix_match(e164, the$geocoding)
    if (is.na(result) || !nzchar(result)) NA_character_ else result
  }, character(1), USE.NAMES = FALSE)
}

#' Look up the timezone for a phone number
#'
#' Returns the primary IANA timezone identifier (e.g., `"America/New_York"`,
#' `"Pacific/Auckland"`) associated with a phone number prefix. When multiple
#' timezones match, the first is returned; use [phone_timezones()] to get all.
#'
#' @inheritParams phone_carrier
#'
#' @return Character vector of IANA timezone identifiers, or `NA_character_`
#'   where no timezone data is available.
#'
#' @examples
#' phone_timezone("+64211234567")
#' phone_timezone("+12125551234")
#'
#' @export
phone_timezone <- function(number, default_region = NULL) {
  ensure_metadata()
  ensure_lookup("timezones")
  parsed <- phone_parse(number, default_region = default_region)
  vapply(parsed, function(p) {
    if (is.na(p$country_code) || is.na(p$national_number)) return(NA_character_)
    e164 <- paste0(p$country_code, p$national_number)
    result <- longest_prefix_match(e164, the$timezones)
    if (is.na(result)) return(NA_character_)
    # result is a character vector of timezones; return first
    result[1]
  }, character(1), USE.NAMES = FALSE)
}

#' Look up all timezones for a phone number
#'
#' Returns all IANA timezone identifiers associated with a phone number prefix.
#' Some prefixes span multiple timezones (e.g., country-level prefixes for
#' large countries).
#'
#' @inheritParams phone_carrier
#'
#' @return A list of character vectors, one per input number. Each element
#'   contains the timezone(s) for that number, or `NA_character_` if no
#'   timezone data is available.
#'
#' @examples
#' phone_timezones("+12125551234")
#' phone_timezones(c("+64211234567", "+12125551234"))
#'
#' @export
phone_timezones <- function(number, default_region = NULL) {
  ensure_metadata()
  ensure_lookup("timezones")
  parsed <- phone_parse(number, default_region = default_region)
  lapply(parsed, function(p) {
    if (is.na(p$country_code) || is.na(p$national_number)) return(NA_character_)
    e164 <- paste0(p$country_code, p$national_number)
    result <- longest_prefix_match(e164, the$timezones)
    if (is.na(result[1])) NA_character_ else result
  })
}

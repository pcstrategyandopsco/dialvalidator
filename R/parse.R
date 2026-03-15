#' Parse a Phone Number
#'
#' Parses a phone number string into its components: country code, national
#' number, and region. Numbers can be provided in international format (with
#' leading `+`) or national format (with `default_region`).
#'
#' @param number Character vector of phone numbers.
#' @param default_region ISO 3166-1 alpha-2 region code (e.g., `"NZ"`, `"US"`)
#'   used when numbers are in national format (no leading `+`). If `NULL`,
#'   numbers without a `+` prefix will fail to parse.
#'
#' @return A list of parsed phone number lists, each with elements:
#'   \describe{
#'     \item{`raw`}{The original input string.}
#'     \item{`country_code`}{Country calling code (e.g., `"64"` for NZ).}
#'     \item{`national_number`}{The national significant number (digits only).}
#'     \item{`region`}{ISO 3166-1 alpha-2 region code.}
#'     \item{`valid`}{Logical indicating if the number is valid.}
#'   }
#'   Returns a list with `valid = FALSE` for numbers that cannot be parsed.
#'
#' @examples
#' phone_parse("+64211234567")
#' phone_parse("021 123 4567", default_region = "NZ")
#' phone_parse(c("+12125551234", "+442071234567"))
#'
#' @export
phone_parse <- function(number, default_region = NULL) {
  ensure_metadata()
  if (!is.null(default_region)) default_region <- toupper(default_region)

  lapply(number, function(x) parse_single(x, default_region))
}

#' Parse a single phone number
#' @noRd
parse_single <- function(x, default_region = NULL) {
  raw <- x
  invalid <- list(
    raw = raw, country_code = NA_character_, national_number = NA_character_,
    region = NA_character_, valid = FALSE
  )

  # Normalize
  normalized <- normalize_number(x)
  if (is.na(normalized)) return(invalid)

  has_plus <- str_starts(normalized, fixed("+"))
  digits <- str_remove_all(normalized, fixed("+"))

  if (has_plus) {
    # International format: extract country code from digits
    extracted <- extract_country_code(digits)
    if (is.null(extracted)) return(invalid)

    cc <- extracted$country_code
    nn <- extracted$national_number
    region <- resolve_region(cc, nn)
  } else if (!is.null(default_region)) {
    # National format: use default_region
    territory <- the$metadata$territories[[default_region]]
    if (is.null(territory)) return(invalid)

    cc <- territory$country_code

    # Try stripping IDD prefix (e.g. "00" or "0161") to handle international
    # dialling from within the default_region
    idd_matched <- FALSE
    idd_prefix <- territory$international_prefix
    if (!is.null(idd_prefix) && nzchar(idd_prefix)) {
      idd_re <- paste0("^(?:", idd_prefix, ")")
      m <- regexpr(idd_re, digits, perl = TRUE)
      if (m > 0) {
        after_idd <- substring(digits, attr(m, "match.length") + 1)
        if (nzchar(after_idd)) {
          extracted <- extract_country_code(after_idd)
          if (!is.null(extracted)) {
            cc <- extracted$country_code
            nn <- extracted$national_number
            region <- resolve_region(cc, nn)
            if (is.na(region)) region <- default_region
            idd_matched <- TRUE
          }
        }
      }
    }

    if (!idd_matched) {
      nn <- strip_national_prefix(digits, territory)
      region <- default_region

      # For shared country codes, verify the number actually belongs to this region
      regions <- the$metadata$cc_to_regions[[cc]]
      if (length(regions) > 1) {
        resolved <- resolve_region(cc, nn)
        if (!is.na(resolved)) region <- resolved
      }

      # If the national number doesn't validate, check if it starts with the
      # country code (bare international number without + or IDD)
      nat_territory <- the$metadata$territories[[region]]
      nat_valid <- if (!is.null(nat_territory)) {
        len_ok <- valid_length(nn, nat_territory)
        pat_ok <- if (!is.null(nat_territory$general_desc$pattern)) {
          str_detect(nn, nat_territory$general_desc$pattern)
        } else TRUE
        len_ok && pat_ok
      } else FALSE
      if (!nat_valid && str_starts(digits, fixed(cc))) {
        stripped <- str_sub(digits, nchar(cc) + 1)
        if (nzchar(stripped)) {
          # Also strip national prefix if present after the country code
          # (e.g. "(64) 0211234567" → digits "640211234567" → strip CC → "0211234567" → strip NP → "211234567")
          stripped_np <- strip_national_prefix(stripped, territory)
          strip_territory <- the$metadata$territories[[region]]
          # Try with national prefix stripped first, then without
          candidate <- stripped_np
          strip_valid <- if (!is.null(strip_territory)) {
            len_ok <- valid_length(candidate, strip_territory)
            pat_ok <- if (!is.null(strip_territory$general_desc$pattern)) {
              str_detect(candidate, strip_territory$general_desc$pattern)
            } else TRUE
            len_ok && pat_ok
          } else FALSE
          if (!strip_valid && !identical(stripped, stripped_np)) {
            # Fall back to without national prefix stripping
            candidate <- stripped
            strip_valid <- if (!is.null(strip_territory)) {
              len_ok <- valid_length(candidate, strip_territory)
              pat_ok <- if (!is.null(strip_territory$general_desc$pattern)) {
                str_detect(candidate, strip_territory$general_desc$pattern)
              } else TRUE
              len_ok && pat_ok
            } else FALSE
          }
          if (strip_valid) {
            nn <- candidate
            # Re-resolve region for shared country codes
            regions <- the$metadata$cc_to_regions[[cc]]
            if (length(regions) > 1) {
              resolved <- resolve_region(cc, nn)
              if (!is.na(resolved)) region <- resolved
            }
          }
        }
      }
    }
  } else {
    return(invalid)
  }

  # Validate length
  territory <- the$metadata$territories[[region]]
  is_valid <- if (!is.null(territory)) valid_length(nn, territory) else FALSE

  # Also validate against general_desc pattern if available
  if (is_valid && !is.null(territory$general_desc$pattern)) {
    is_valid <- str_detect(nn, territory$general_desc$pattern)
  }

  list(
    raw = raw,
    country_code = cc,
    national_number = nn,
    region = region,
    valid = is_valid
  )
}

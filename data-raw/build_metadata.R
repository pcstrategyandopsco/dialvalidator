# build_metadata.R
# Downloads Google's PhoneNumberMetadata.xml and parses it into an R list.
# Run this script to rebuild inst/extdata/metadata.rds.
#
# Requirements: xml2

library(xml2)

# --- Configuration ---
metadata_url <- paste0(

"https://raw.githubusercontent.com/google/libphonenumber/master/",
  "resources/PhoneNumberMetadata.xml"
)
output_path <- file.path("inst", "extdata", "metadata.rds")

# --- Download XML ---
cli::cli_alert_info("Downloading PhoneNumberMetadata.xml...")
xml <- read_xml(metadata_url)

# --- Helper: parse a number-type node (mobile, fixed_line, etc.) ---
parse_number_type <- function(territory_node, type_name) {
  node <- xml_find_first(territory_node, type_name)
  if (is.na(node)) return(NULL)

  pattern_node <- xml_find_first(node, "nationalNumberPattern")
  pattern <- if (!is.na(pattern_node)) {
    raw <- trimws(gsub("\\s+", "", xml_text(pattern_node)))
    paste0("^(?:", raw, ")$")
  }

  lengths_node <- xml_find_first(node, "possibleLengths")
  possible_lengths <- if (!is.na(lengths_node)) {
    len_str <- xml_attr(lengths_node, "national")
    if (!is.null(len_str) && !is.na(len_str)) {
      parts <- strsplit(len_str, ",")[[1]]
      unlist(lapply(parts, function(p) {
        if (grepl("\\[", p)) {
          bounds <- as.integer(regmatches(p, gregexpr("[0-9]+", p))[[1]])
          seq(bounds[1], bounds[2])
        } else {
          as.integer(p)
        }
      }))
    }
  }

  example_node <- xml_find_first(node, "exampleNumber")
  example <- if (!is.na(example_node)) xml_text(example_node)

  list(
    pattern = pattern,
    possible_lengths = possible_lengths,
    example = example
  )
}

# --- Helper: parse formatting rules ---
parse_formats <- function(territory_node) {
  # Formats can be in the territory itself or inherited via a parent reference
  format_nodes <- xml_find_all(territory_node, "availableFormats/numberFormat")
  if (length(format_nodes) == 0) return(list())

  lapply(format_nodes, function(fmt) {
    pattern <- xml_attr(fmt, "pattern")
    format_text <- xml_text(xml_find_first(fmt, "format"))

    leading_digits <- xml_find_all(fmt, "leadingDigits")
    leading_digits_patterns <- if (length(leading_digits) > 0) {
      vapply(leading_digits, function(ld) {
        trimws(gsub("\\s+", "", xml_text(ld)))
      }, character(1))
    }

    npfr <- xml_attr(fmt, "nationalPrefixFormattingRule")
    intl_format_node <- xml_find_first(fmt, "intlFormat")
    intl_format <- if (!is.na(intl_format_node)) xml_text(intl_format_node)

    result <- list(
      pattern = pattern,
      format = format_text,
      leading_digits_patterns = leading_digits_patterns,
      national_prefix_formatting_rule = npfr
    )
    if (!is.null(intl_format)) result$intl_format <- intl_format
    result
  })
}

# --- Phone number types to extract ---
phone_types <- c(
  "generalDesc", "fixedLine", "mobile", "tollFree", "premiumRate",
  "sharedCost", "personalNumber", "voip", "pager", "uan", "voicemail",
  "noInternationalDialling"
)

# R-friendly names
type_names_r <- c(
  "general_desc", "fixed_line", "mobile", "toll_free", "premium_rate",
  "shared_cost", "personal_number", "voip", "pager", "uan", "voicemail",
  "no_international_dialling"
)

# --- Parse all territories ---
cli::cli_alert_info("Parsing territories...")
territory_nodes <- xml_find_all(xml, "//territory")
cli::cli_alert_info("Found {length(territory_nodes)} territory nodes")

territories <- list()
cc_to_regions <- list()
example_numbers <- list()

for (tnode in territory_nodes) {
  id <- xml_attr(tnode, "id")
  cc <- xml_attr(tnode, "countryCode")
  national_prefix <- xml_attr(tnode, "nationalPrefix")
  international_prefix <- xml_attr(tnode, "internationalPrefix")
  main_country <- xml_attr(tnode, "mainCountryForCode")
  leading_digits <- xml_attr(tnode, "leadingDigits")

  # Build territory entry
  territory <- list(
    id = id,
    country_code = cc,
    national_prefix = if (!is.na(national_prefix)) national_prefix,
    international_prefix = if (!is.na(international_prefix)) international_prefix,
    main_country_for_code = if (!is.na(main_country)) as.logical(main_country),
    leading_digits = if (!is.na(leading_digits)) trimws(gsub("\\s+", "", leading_digits))
  )

  # Parse each phone number type
  for (i in seq_along(phone_types)) {
    parsed <- parse_number_type(tnode, phone_types[i])
    if (!is.null(parsed)) {
      territory[[type_names_r[i]]] <- parsed
      # Collect example numbers
      if (!is.null(parsed$example) && type_names_r[i] != "general_desc") {
        example_numbers[[length(example_numbers) + 1]] <- list(
          region = id,
          country_code = cc,
          type = type_names_r[i],
          example = parsed$example
        )
      }
    }
  }

  # Parse formatting rules
  territory$formats <- parse_formats(tnode)

  territories[[id]] <- territory

  # Build country_code → regions reverse index
  if (is.null(cc_to_regions[[cc]])) {
    cc_to_regions[[cc]] <- id
  } else {
    cc_to_regions[[cc]] <- c(cc_to_regions[[cc]], id)
  }
}

# Sort regions within each country code: main country first
for (cc in names(cc_to_regions)) {
  regions <- cc_to_regions[[cc]]
  if (length(regions) > 1) {
    main_first <- vapply(regions, function(r) {
      isTRUE(territories[[r]]$main_country_for_code)
    }, logical(1))
    cc_to_regions[[cc]] <- c(regions[main_first], regions[!main_first])
  }
}

# --- Build metadata object ---
# Try to get version from XML
version_comment <- xml_find_first(xml, "//comment()")
version_str <- if (!is.na(version_comment)) {
  txt <- xml_text(version_comment)
  m <- regmatches(txt, regexpr("[0-9]+\\.[0-9]+", txt))
  if (length(m) > 0) m else "unknown"
} else {
  "unknown"
}

metadata <- list(
  cc_to_regions = cc_to_regions,
  territories = territories,
  example_numbers = example_numbers,
  version = version_str,
  built = Sys.Date()
)

# --- Save ---
cli::cli_alert_info("Saving metadata to {output_path}...")
dir.create(dirname(output_path), recursive = TRUE, showWarnings = FALSE)
saveRDS(metadata, output_path, compress = "xz")

file_size <- file.size(output_path)
cli::cli_alert_success(
  "Done! {length(territories)} territories, {length(example_numbers)} examples. ",
  "File size: {round(file_size / 1024)} KB"
)

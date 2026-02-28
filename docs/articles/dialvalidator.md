# Getting started with dialvalidator

## Overview

dialvalidator parses, validates, formats, and classifies international
phone numbers using Google’s
[libphonenumber](https://github.com/google/libphonenumber) metadata. It
covers 240+ territories and requires no Java runtime – the metadata is
pre-parsed into a native R object and shipped with the package.

``` r

library(dialvalidator)
```

## Validating numbers

[`phone_valid()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_valid.md)
checks whether a number is valid for its territory. Numbers can be
supplied in international format (with a leading `+`) or national format
(with a `default_region`):

``` r

# International format -- region inferred from country code
phone_valid("+64211234567")
#> [1] TRUE

# National format -- supply the region
phone_valid("021 123 4567", default_region = "NZ")
#> [1] TRUE

# Invalid: too short
phone_valid("+6421")
#> [1] FALSE

# Vectorised
phone_valid(c("+64211234567", "+12125551234", "not a number", "+61412345678"))
#> [1]  TRUE  TRUE FALSE  TRUE
```

## Formatting numbers

Three output formats, matching libphonenumber’s conventions:

``` r

# E.164: compact, no spaces, machine-readable
phone_format("+64211234567", "E164")
#> [1] "+64211234567"

# National: how you'd dial it locally
phone_format("+64211234567", "NATIONAL")
#> [1] "021 123 4567"

# International: with country code and spacing
phone_format("+64211234567", "INTERNATIONAL")
#> [1] "+64 21 123 4567"
```

Formatting rules are territory-specific – the same function handles US
parenthesised area codes, UK spacing, and every other convention:

``` r

phone_format("+12125551234", "NATIONAL")
#> [1] "(212) 555-1234"
phone_format("+442071234567", "NATIONAL")
#> [1] "020 7123 4567"
phone_format("+61412345678", "NATIONAL")
#> [1] "0412 345 678"
```

## Detecting number type

[`phone_type()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_type.md)
classifies numbers by matching against per-territory patterns for each
number type:

``` r

# NZ mobile
phone_type("+64211234567")
#> [1] "mobile"

# US toll-free
phone_type("+18005551234")
#> [1] "toll_free"
```

Possible types: `mobile`, `fixed_line`, `fixed_line_or_mobile`,
`toll_free`, `premium_rate`, `shared_cost`, `personal_number`, `voip`,
`pager`, `uan`, `voicemail`, `unknown`.

## Country resolution

[`phone_country()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_country.md)
returns the ISO 3166-1 alpha-2 region code. For shared country codes
like +1 (NANPA), the package resolves the correct territory using
area-code-level patterns:

``` r

phone_country(c("+64211234567", "+12125551234", "+14165551234", "+442071234567"))
#> [1] "NZ" "US" "CA" "GB"
```

Note that +1 212 resolves to US (New York) while +1 416 resolves to CA
(Toronto).

## All-in-one with phone_info()

For batch processing or exploratory analysis,
[`phone_info()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_info.md)
returns everything in a single data frame:

``` r

phone_info(c("+64211234567", "+12125551234", "+61412345678", "+81312345678"))
#>            raw         e164       national   international region country_code
#> 1 +64211234567 +64211234567   021 123 4567 +64 21 123 4567     NZ           64
#> 2 +12125551234 +12125551234 (212) 555-1234 +1 212-555-1234     US            1
#> 3 +61412345678 +61412345678   0412 345 678 +61 412 345 678     AU           61
#> 4 +81312345678 +81312345678   03-1234-5678 +81 3-1234-5678     JP           81
#>                   type valid
#> 1               mobile  TRUE
#> 2 fixed_line_or_mobile  TRUE
#> 3               mobile  TRUE
#> 4           fixed_line  TRUE
```

## Working with national-format numbers

When processing numbers from a known country, set `default_region` once:

``` r

nz_numbers <- c("021 123 4567", "09 300 1234", "0800 123 456")
phone_info(nz_numbers, default_region = "NZ")
#>            raw         e164     national   international region country_code
#> 1 021 123 4567 +64211234567 021 123 4567 +64 21 123 4567     NZ           64
#> 2  09 300 1234  +6493001234  09 300 1234  +64 9 300 1234     NZ           64
#> 3 0800 123 456 +64800123456 0800 123 456 +64 800 123 456     NZ           64
#>         type valid
#> 1     mobile  TRUE
#> 2 fixed_line  TRUE
#> 3  toll_free  TRUE
```

## Inspecting metadata

You can inspect the underlying libphonenumber metadata for any
territory:

``` r

nz <- dv_territory("NZ")
nz$country_code
#> [1] "64"
nz$national_prefix
#> [1] "0"
nz$mobile$example
#> [1] "211234567"
```

## Updating metadata

The bundled metadata is current as of the package build date. To fetch
the latest version from Google’s repository:

``` r

dv_update_metadata()
```

Updated metadata is cached locally and used for the remainder of the
session. No internet access is needed during normal use.

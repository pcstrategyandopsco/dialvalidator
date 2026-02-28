# Getting started with dialvalidator

## Overview

dialvalidator parses, validates, formats, and classifies phone numbers
using Google’s libphonenumber metadata. It covers 240+ territories and
requires no Java runtime.

``` r

library(dialvalidator)
```

## Parsing numbers

Numbers can be supplied in international format (with a leading `+`) or
in national format with a `default_region`:

``` r

# International format — region is inferred
phone_parse("+64211234567")
#> [[1]]
#> [[1]]$raw
#> [1] "+64211234567"
#> 
#> [[1]]$country_code
#> [1] "64"
#> 
#> [[1]]$national_number
#> [1] "211234567"
#> 
#> [[1]]$region
#> [1] "NZ"
#> 
#> [[1]]$valid
#> [1] TRUE

# National format — supply the region
phone_parse("021 123 4567", default_region = "NZ")
#> [[1]]
#> [[1]]$raw
#> [1] "021 123 4567"
#> 
#> [[1]]$country_code
#> [1] "64"
#> 
#> [[1]]$national_number
#> [1] "211234567"
#> 
#> [[1]]$region
#> [1] "NZ"
#> 
#> [[1]]$valid
#> [1] TRUE
```

## Validating numbers

[`phone_valid()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_valid.md)
returns a logical vector:

``` r

phone_valid(c("+64211234567", "+6421", "not a number"))
#> [1]  TRUE FALSE FALSE
```

## Formatting numbers

Three output formats are supported:

``` r

phone_format("+64211234567", "E164")
#> [1] "+64211234567"
phone_format("+64211234567", "NATIONAL")
#> [1] "021 123 4567"
phone_format("+64211234567", "INTERNATIONAL")
#> [1] "+64 21 123 4567"
```

## Detecting type and country

``` r

phone_type(c("+64211234567", "+6493001234", "+18005551234"))
#> [1] "mobile"     "fixed_line" "toll_free"
phone_country(c("+64211234567", "+12125551234", "+442071234567"))
#> [1] "NZ" "US" "GB"
```

## All-in-one with phone_info()

For batch processing,
[`phone_info()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_info.md)
returns a data frame with all fields:

``` r

phone_info(c("+64211234567", "+12125551234", "+61412345678"))
#>            raw         e164       national   international region country_code
#> 1 +64211234567 +64211234567   021 123 4567 +64 21 123 4567     NZ           64
#> 2 +12125551234 +12125551234 (212) 555-1234 +1 212-555-1234     US            1
#> 3 +61412345678 +61412345678   0412 345 678 +61 412 345 678     AU           61
#>                   type valid
#> 1               mobile  TRUE
#> 2 fixed_line_or_mobile  TRUE
#> 3               mobile  TRUE
```

## Updating metadata

The bundled metadata is current as of the package build date. To fetch
the latest version from Google’s repository:

``` r

dv_update_metadata()
```

Updated metadata is cached locally and used for the remainder of the
session.

## Working with national numbers

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

## NANPA (North American Numbering Plan)

Country code +1 is shared by the US, Canada, and Caribbean nations.
dialvalidator resolves the correct region using territory-specific area
code patterns:

``` r

phone_country(c("+12125551234", "+14165551234"))
#> [1] "US" "CA"
```

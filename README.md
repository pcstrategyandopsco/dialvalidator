# dialvalidator <a href="https://pcstrategyandopsco.github.io/dialvalidator/"><img src="man/figures/logo.png" align="right" height="139" alt="dialvalidator logo" /></a>

Phone number validation for R using Google's
[libphonenumber](https://github.com/google/libphonenumber) metadata.
No Java required.

## Installation

```r
# install.packages("pak")
pak::pak("pcstrategyandopsco/dialvalidator")
```

## Quick start

```r
library(dialvalidator)

# Validate
phone_valid("+64211234567")
#> TRUE

# Format
phone_format("+64211234567", "NATIONAL")
#> "021 123 4567"

phone_format("+64211234567", "INTERNATIONAL")
#> "+64 21 123 4567"

# Detect type and country
phone_type("+64211234567")
#> "mobile"

phone_country("+64211234567")
#> "NZ"

# National format with default region
phone_valid("021 123 4567", default_region = "NZ")
#> TRUE

# All-in-one
phone_info(c("+64211234567", "+12125551234"))
#>            raw         e164       national   international region country_code   type valid
#> 1 +64211234567 +64211234567   021 123 4567 +64 21 123 4567     NZ           64 mobile  TRUE
#> 2 +12125551234 +12125551234 (212) 555-1234 +1 212-555-1234     US            1 ...    TRUE
```

## Functions

| Function | Returns | Description |
|----------|---------|-------------|
| `phone_parse()` | list | Parse into components (country code, national number, region) |
| `phone_valid()` | logical | Is the number valid? |
| `phone_format()` | character | Format as E164, NATIONAL, or INTERNATIONAL |
| `phone_type()` | character | Classify as mobile, fixed_line, toll_free, etc. |
| `phone_country()` | character | ISO 3166-1 alpha-2 region code |
| `phone_info()` | data.frame | All of the above in one call |

All functions are vectorised: pass a character vector, get a vector (or data frame) back.

## Metadata

The package ships with pre-parsed metadata from libphonenumber covering
240+ territories. To update to the latest upstream metadata:

```r
dv_update_metadata()
```

This downloads the current `PhoneNumberMetadata.xml`, parses it, and caches
the result in `tools::R_user_dir("dialvalidator", "cache")`. No internet
access is needed at install time or during normal use.

## Comparison to dialr

| | dialvalidator | dialr |
|---|---|---|
| Java required | No | Yes (rJava) |
| Dependencies | stringr, cli, rlang | rJava, libphonenumber JAR |
| Install complexity | `pak::pak()` | JDK + rJava configuration |
| Metadata updates | `dv_update_metadata()` | Update JAR |
| Coverage | 240+ territories | 240+ territories |

## Attribution

This package uses metadata from Google's
[libphonenumber](https://github.com/google/libphonenumber) project,
licensed under the Apache License 2.0. No Java code is included.

## License

Apache License 2.0

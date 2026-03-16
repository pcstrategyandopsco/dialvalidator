# Look up all timezones for a phone number

Returns all IANA timezone identifiers associated with a phone number
prefix. Some prefixes span multiple timezones (e.g., country-level
prefixes for large countries).

## Usage

``` r
phone_timezones(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers (E164 or national format).

- default_region:

  Default ISO 3166-1 alpha-2 region code for parsing national-format
  numbers (e.g., `"NZ"`, `"US"`).

## Value

A list of character vectors, one per input number. Each element contains
the timezone(s) for that number, or `NA_character_` if no timezone data
is available.

## Examples

``` r
phone_timezones("+12125551234")
#> [[1]]
#> [1] "America/New_York"
#> 
phone_timezones(c("+64211234567", "+12125551234"))
#> [[1]]
#> [1] "Pacific/Auckland"
#> 
#> [[2]]
#> [1] "America/New_York"
#> 
```

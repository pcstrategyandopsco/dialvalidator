# Look up the timezone for a phone number

Returns the primary IANA timezone identifier (e.g.,
`"America/New_York"`, `"Pacific/Auckland"`) associated with a phone
number prefix. When multiple timezones match, the first is returned; use
[`phone_timezones()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_timezones.md)
to get all.

## Usage

``` r
phone_timezone(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers (E164 or national format).

- default_region:

  Default ISO 3166-1 alpha-2 region code for parsing national-format
  numbers (e.g., `"NZ"`, `"US"`).

## Value

Character vector of IANA timezone identifiers, or `NA_character_` where
no timezone data is available.

## Examples

``` r
phone_timezone("+64211234567")
#> [1] "Pacific/Auckland"
phone_timezone("+12125551234")
#> [1] "America/New_York"
```

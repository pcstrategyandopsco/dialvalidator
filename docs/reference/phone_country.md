# Detect Country of a Phone Number

Returns the ISO 3166-1 alpha-2 region code for each phone number.

## Usage

``` r
phone_country(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers.

- default_region:

  ISO 3166-1 alpha-2 region code for numbers in national format. See
  [`phone_parse()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_parse.md)
  for details.

## Value

Character vector of region codes (e.g., `"NZ"`, `"US"`). Returns `NA`
for numbers that cannot be parsed.

## Examples

``` r
phone_country("+64211234567")
#> [1] "NZ"
phone_country(c("+12125551234", "+442071234567"))
#> [1] "US" "GB"
```

# Validate Phone Numbers

Checks whether phone numbers are valid according to libphonenumber's
metadata. A number is valid if it parses successfully, has a valid
length, and matches the general number pattern for its region.

## Usage

``` r
phone_valid(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers.

- default_region:

  ISO 3166-1 alpha-2 region code for numbers in national format. See
  [`phone_parse()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_parse.md)
  for details.

## Value

Logical vector. `TRUE` for valid numbers, `FALSE` otherwise. `NA` inputs
return `FALSE`.

## Examples

``` r
phone_valid("+64211234567")
#> [1] TRUE
phone_valid(c("+64211234567", "+6421", "not a number"))
#> [1]  TRUE FALSE FALSE
phone_valid("021 123 4567", default_region = "NZ")
#> [1] TRUE
```

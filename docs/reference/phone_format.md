# Format Phone Numbers

Formats phone numbers according to standard conventions.

## Usage

``` r
phone_format(
  number,
  format = c("E164", "NATIONAL", "INTERNATIONAL"),
  default_region = NULL
)
```

## Arguments

- number:

  Character vector of phone numbers.

- format:

  One of `"E164"` (default), `"NATIONAL"`, or `"INTERNATIONAL"`.

  `E164`

  :   `+64211234567` — compact international format with no spaces.

  `NATIONAL`

  :   `021 123 4567` — local dialling format with national prefix.

  `INTERNATIONAL`

  :   `+64 21 123 4567` — international format with spaces.

- default_region:

  ISO 3166-1 alpha-2 region code for numbers in national format. See
  [`phone_parse()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_parse.md)
  for details.

## Value

Character vector of formatted numbers. Returns `NA` for numbers that
cannot be parsed.

## Examples

``` r
phone_format("+64211234567")
#> [1] "+64211234567"
phone_format("+64211234567", "NATIONAL")
#> [1] "021 123 4567"
phone_format("+64211234567", "INTERNATIONAL")
#> [1] "+64 21 123 4567"
```

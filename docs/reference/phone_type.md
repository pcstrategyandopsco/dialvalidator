# Detect Phone Number Type

Classifies phone numbers as mobile, fixed-line, toll-free, etc. by
matching against libphonenumber's per-territory type patterns.

## Usage

``` r
phone_type(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers.

- default_region:

  ISO 3166-1 alpha-2 region code for numbers in national format. See
  [`phone_parse()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_parse.md)
  for details.

## Value

Character vector of phone number types. Possible values: `"mobile"`,
`"fixed_line"`, `"fixed_line_or_mobile"`, `"toll_free"`,
`"premium_rate"`, `"shared_cost"`, `"personal_number"`, `"voip"`,
`"pager"`, `"uan"`, `"voicemail"`, `"unknown"`. Returns `NA` for numbers
that cannot be parsed.

## Examples

``` r
phone_type("+64211234567")
#> [1] "mobile"
phone_type(c("+6493001234", "+64800123456"))
#> [1] "fixed_line" "toll_free" 
```

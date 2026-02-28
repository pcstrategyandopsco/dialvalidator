# Get All Phone Number Information

Parses, validates, formats, and classifies phone numbers in a single
call. Returns a data frame with one row per input number.

## Usage

``` r
phone_info(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers.

- default_region:

  ISO 3166-1 alpha-2 region code for numbers in national format. See
  [`phone_parse()`](https://pcstrategyandopsco.github.io/dialvalidator/reference/phone_parse.md)
  for details.

## Value

A data frame with columns:

- `raw`:

  Original input.

- `e164`:

  E.164 formatted number.

- `national`:

  National format.

- `international`:

  International format.

- `region`:

  ISO 3166-1 alpha-2 region code.

- `country_code`:

  Country calling code.

- `type`:

  Number type (mobile, fixed_line, etc.).

- `valid`:

  Logical validation result.

## Examples

``` r
phone_info("+64211234567")
#>            raw         e164     national   international region country_code
#> 1 +64211234567 +64211234567 021 123 4567 +64 21 123 4567     NZ           64
#>     type valid
#> 1 mobile  TRUE
phone_info(c("+64211234567", "+12125551234"))
#>            raw         e164       national   international region country_code
#> 1 +64211234567 +64211234567   021 123 4567 +64 21 123 4567     NZ           64
#> 2 +12125551234 +12125551234 (212) 555-1234 +1 212-555-1234     US            1
#>                   type valid
#> 1               mobile  TRUE
#> 2 fixed_line_or_mobile  TRUE
```

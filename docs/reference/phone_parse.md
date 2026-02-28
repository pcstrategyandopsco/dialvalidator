# Parse a Phone Number

Parses a phone number string into its components: country code, national
number, and region. Numbers can be provided in international format
(with leading `+`) or national format (with `default_region`).

## Usage

``` r
phone_parse(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers.

- default_region:

  ISO 3166-1 alpha-2 region code (e.g., `"NZ"`, `"US"`) used when
  numbers are in national format (no leading `+`). If `NULL`, numbers
  without a `+` prefix will fail to parse.

## Value

A list of parsed phone number lists, each with elements:

- `raw`:

  The original input string.

- `country_code`:

  Country calling code (e.g., `"64"` for NZ).

- `national_number`:

  The national significant number (digits only).

- `region`:

  ISO 3166-1 alpha-2 region code.

- `valid`:

  Logical indicating if the number is valid.

Returns a list with `valid = FALSE` for numbers that cannot be parsed.

## Examples

``` r
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
#> 
#> 
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
#> 
#> 
phone_parse(c("+12125551234", "+442071234567"))
#> [[1]]
#> [[1]]$raw
#> [1] "+12125551234"
#> 
#> [[1]]$country_code
#> [1] "1"
#> 
#> [[1]]$national_number
#> [1] "2125551234"
#> 
#> [[1]]$region
#> [1] "US"
#> 
#> [[1]]$valid
#> [1] TRUE
#> 
#> 
#> [[2]]
#> [[2]]$raw
#> [1] "+442071234567"
#> 
#> [[2]]$country_code
#> [1] "44"
#> 
#> [[2]]$national_number
#> [1] "2071234567"
#> 
#> [[2]]$region
#> [1] "GB"
#> 
#> [[2]]$valid
#> [1] TRUE
#> 
#> 
```

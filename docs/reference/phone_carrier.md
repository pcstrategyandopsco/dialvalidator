# Look up the carrier for a phone number

Returns the carrier name (e.g., "O2", "Vodafone") associated with a
mobile number prefix. Landline numbers typically have no carrier data
and return `NA`.

## Usage

``` r
phone_carrier(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers (E164 or national format).

- default_region:

  Default ISO 3166-1 alpha-2 region code for parsing national-format
  numbers (e.g., `"NZ"`, `"US"`).

## Value

Character vector of carrier names, or `NA_character_` where no carrier
data is available.

## Examples

``` r
phone_carrier("+61412345678")
#> [1] "Optus"
phone_carrier("0412345678", default_region = "AU")
#> [1] "Optus"
```

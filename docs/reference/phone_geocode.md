# Look up the geographic location for a phone number

Returns the geographic description (e.g., "Leeds", "Auckland")
associated with a phone number prefix. Mobile numbers typically have no
geocoding data and return `NA`.

## Usage

``` r
phone_geocode(number, default_region = NULL)
```

## Arguments

- number:

  Character vector of phone numbers (E164 or national format).

- default_region:

  Default ISO 3166-1 alpha-2 region code for parsing national-format
  numbers (e.g., `"NZ"`, `"US"`).

## Value

Character vector of location descriptions, or `NA_character_` where no
geocoding data is available.

## Examples

``` r
phone_geocode("+12125551234")
#> [1] "New York, NY"
phone_geocode("+442071234567")
#> [1] "London"
```

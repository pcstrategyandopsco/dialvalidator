# Get metadata for a specific territory

Get metadata for a specific territory

## Usage

``` r
dv_territory(region)
```

## Arguments

- region:

  ISO 3166-1 alpha-2 region code (e.g., `"NZ"`, `"US"`).

## Value

A list containing the territory's country code, national prefix, phone
type patterns, formatting rules, and example numbers. Returns `NULL` if
the region is not found.

## Examples

``` r
nz <- dv_territory("NZ")
nz$country_code
#> [1] "64"
nz$mobile$example
#> [1] "211234567"
```

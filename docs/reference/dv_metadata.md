# Get the full metadata object

Returns the parsed libphonenumber metadata used internally by all
validation functions. Useful for inspection and debugging.

## Usage

``` r
dv_metadata()
```

## Value

A list with elements `cc_to_regions`, `territories`, `example_numbers`,
`version`, and `built`.

## Examples

``` r
meta <- dv_metadata()
meta$version
#> [1] "2.0"
length(meta$territories)
#> [1] 246
```

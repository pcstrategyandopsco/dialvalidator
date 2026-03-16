# Update lookup data from upstream

Downloads the latest carrier, geocoding, and timezone data from Google's
libphonenumber repository, and saves the results to the user's cache
directory. The updated data is used for the remainder of the session.

## Usage

``` r
dv_update_lookups()
```

## Value

Invisibly returns a character vector of cache file paths.

## Details

Requires the jsonlite package for listing carrier/geocoding files.

## Examples

``` r
# \donttest{
dv_update_lookups()
#> ℹ Downloading carrier data...
#> ✔ Carrier: 28871 prefixes
#> ℹ Downloading geocoding data...
#> ✔ Geocoding: 266157 prefixes
#> ℹ Downloading timezone data...
#> ✔ Timezones: 3290 prefixes
# }
```

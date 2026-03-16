# Update metadata from upstream

Downloads the latest `PhoneNumberMetadata.xml` from Google's
libphonenumber repository, parses it, and saves the result to the user's
cache directory. The updated metadata is used for the remainder of the
session.

## Usage

``` r
dv_update_metadata(
  url = paste0("https://raw.githubusercontent.com/google/libphonenumber/master/",
    "resources/PhoneNumberMetadata.xml")
)
```

## Arguments

- url:

  URL to the raw PhoneNumberMetadata.xml file. Defaults to the master
  branch on GitHub.

## Value

Invisibly returns the path to the cached metadata file.

## Details

Requires the xml2 package.

## Examples

``` r
# \donttest{
dv_update_metadata()
#> ℹ Downloading PhoneNumberMetadata.xml...
#> ℹ Parsing metadata...
#> ✔ Updated to version live (246 territories). Cached at /Users/peeyooshchandra/Library/Caches/org.R-project.R/R/dialvalidator/metadata.rds
# }
```

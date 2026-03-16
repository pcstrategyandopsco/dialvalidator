# dialvalidator 0.1.2

* Add carrier, geocoding, and timezone lookup functions (`dv_carrier()`,
  `dv_geocoding()`, `dv_timezone()`) with bundled upstream data.
* Add `dv_update_lookups()` to refresh lookup data from upstream.
* Use `\dontrun` for examples that download from GitHub or write to the
  user cache directory, fixing a CRAN check NOTE.

# dialvalidator 0.1.1

* Fix phone number parsing to honour `international_prefix` and
  `country_code` from XML metadata. Formats using IDD prefixes
  (e.g. `006421303960`) and bare country codes (e.g. `64272306822`)
  now parse correctly.

# dialvalidator 0.1.0

* Initial CRAN release.
* Parses, validates, formats, and classifies phone numbers using Google's
  libphonenumber metadata.
* Covers 240+ territories with support for mobile, landline, toll-free,
  and other number types.
* No Java runtime required — metadata is pre-parsed and bundled.

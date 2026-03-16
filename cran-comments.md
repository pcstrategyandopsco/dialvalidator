## R CMD check results

0 errors | 0 warnings | 0 notes

## Resubmission

This is an update to the published 0.1.0 release, addressing the
additional-issues NOTE from CRAN checks:

- `dv_update_metadata()` example was wrapped in `\donttest{}`, which
  CRAN runs. The function writes to `tools::R_user_dir()`, triggering a
  NOTE about files left in `~/.cache/R/dialvalidator/`. Changed to
  `\dontrun{}` to match `dv_update_lookups()`.

Other changes since 0.1.0:

- Add carrier, geocoding, and timezone lookup functions.
- Fix phone number parsing to honour international_prefix and
  country_code from XML metadata.

## Test environments

- local macOS Sequoia 15.5 (aarch64), R 4.5.2
- GitHub Actions: ubuntu-latest (R release, devel, oldrel-1)
- GitHub Actions: macos-14 (R release)
- GitHub Actions: windows-latest (R release)

## Downstream dependencies

No reverse dependencies.

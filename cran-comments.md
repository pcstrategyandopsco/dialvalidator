## R CMD check results

0 errors | 0 warnings | 0 notes

## Test environments

- local macOS Sequoia 15.5 (aarch64), R 4.5.2
- GitHub Actions: ubuntu-latest (R release, devel, oldrel-1)
- GitHub Actions: macos-latest (R release)
- GitHub Actions: windows-latest (R release)
- R-hub: linux (R-devel)
- R-hub: macos-arm64 (R-devel)
- R-hub: windows (R-devel)
- R-hub: ubuntu-clang (R-devel)

## Downstream dependencies

This is a new package with no reverse dependencies.

## Notes

This package ships pre-parsed metadata (~54 KB RDS) from Google's
libphonenumber project (Apache 2.0 licensed). The metadata is parsed at
build time from PhoneNumberMetadata.xml and does not require network
access at install or runtime.

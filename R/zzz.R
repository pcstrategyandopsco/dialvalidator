# Internal environment for package state
the <- new.env(parent = emptyenv())

.onLoad <- function(libname, pkgname) {
  metadata_path <- system.file("extdata", "metadata.rds", package = pkgname)
  if (nzchar(metadata_path) && file.exists(metadata_path)) {
    the$metadata <- readRDS(metadata_path)
  }

  carrier_path <- system.file("extdata", "carrier.rds", package = pkgname)
  if (nzchar(carrier_path) && file.exists(carrier_path)) {
    the$carrier <- readRDS(carrier_path)
  }

  geocoding_path <- system.file("extdata", "geocoding.rds", package = pkgname)
  if (nzchar(geocoding_path) && file.exists(geocoding_path)) {
    the$geocoding <- readRDS(geocoding_path)
  }

  timezones_path <- system.file("extdata", "timezones.rds", package = pkgname)
  if (nzchar(timezones_path) && file.exists(timezones_path)) {
    the$timezones <- readRDS(timezones_path)
  }
}

#' toolAggregateByLandType
#'
#' Aggregate raster object by land type and return as 0.25degx0.25deg magclass
#' object
#'
#' @param x data to be aggregated
#' @param weight weight to be used for aggregation (land type)
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @seealso \code{\link{calcOutput}}

toolAggregateByLandType <- function(x, weight) {

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  # align data sets by projecting x onto weight and masking weight onto x
  x    <- terra::project(x, weight)
  weight <- terra::mask(weight, x)
  message("Data sets aligned (1/4)")

  # aggregate weight to intermediate target resolution
  # (for further processing to happen in memory)
  res <- terra::res(x)[1]
  weight25 <- terra::aggregate(weight, fact = round(0.25 / res), fun = "sum", na.rm = TRUE)
  message("Land use aggregation to 0.25deg completed. (2/4)")

  # area weighted aggregation of x to 0.25 degree
  x25 <- terra::aggregate(x * weight, fact = round(0.25 / res), fun = "sum", na.rm = TRUE) / weight25
  names(x25) <- names(weight25)
  message("Area weighted data aggregation to 0.25deg completed. (3/4)")

  # convert to magpie objects and clean coordinate values
  .clean2magpie <- function(x) {
    x <- as.magpie(x)
    getCoords(x) <- round(getCoords(x), 3)
    return(x)
  }

  # add country ISO codes
  .getCountryTemplate <- function() {
    worldCountries <- calcOutput("WorldCountries", aggregate = FALSE)
    worldRaster <- terra::rasterize(worldCountries, x25, "ISO", touches = TRUE)
    template <- .clean2magpie(worldRaster)
    return(template)
  }

  .fixCountries <- function(x, missingValue, silent = FALSE) {
    status <- getItems(x, "country")
    target <- getISOlist()
    # remove cells not mapped to a country
    unknown <- setdiff(status, target)
    missing <- setdiff(target, status)
    if (length(unknown) > 0) {
      if (!isTRUE(silent)) {
        warning('Remove cells with unknown country codes: "', paste0(unknown, collapse = '", "'), '"')
      }
      x <- x[unknown, , , invert = TRUE]
    }
    if (length(missing) > 0) {
      if (!isTRUE(silent)) {
        message('Add empty cells for missing countries: "', paste0(missing, collapse = '", "'), '"')
      }
      tmp <- x[seq_along(missing), , ]
      tmp[, , ] <- missingValue
      getItems(tmp, dim = 1, raw = TRUE) <- paste0("-70p125.25p125.", missing)
      x <- mbind(x, tmp)
    }
    return(x)
  }

  .convert2magpie <- function(x, template, missing = NA, silent = FALSE) {
    x <- .clean2magpie(x)
    countries <- as.vector(template)
    out <- new.magpie(getItems(template, dim = 1), getItems(x, dim = 2), getItems(x, dim = 3), fill = missing)
    getSets(out) <- getSets(x)

    match <- intersect(getItems(out, dim = 1, split = FALSE), getItems(x, dim = 1, split = FALSE))
    out[match, , ] <- x[match, , ]
    getItems(out, dim = "country", maindim = 1) <- countries
    return(.fixCountries(out, missing, silent))
  }

  template <- .getCountryTemplate()
  x        <- .convert2magpie(x25, template, missing = 0)
  weight   <- .convert2magpie(weight25, template, missing = 10^-10, silent = TRUE)
  message("Conversion to magclass completed. (4/4)")

  return(list(x = x, weight = weight))
}

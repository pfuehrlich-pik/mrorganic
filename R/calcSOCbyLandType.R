#' Calculate SOC by land type
#'
#' Estimate soil organic carbon content split by land type
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("SOCbyLandType")
#' }
#' @seealso \code{\link{calcOutput}}

calcSOCbyLandType <- function() {

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  message("Please be patient, this will take now a while.")

  # read in SOC data
  soc <- readSource("GSOCseq", subtype = "ini", convert = FALSE)

  # get soc resolution
  res <- round(terra::res(soc)[1], 9)

  # read in aggregated area information and setting zeroValue to 10^-10 to ensure
  # that all values are > 0 so that it can be used as weight
  weight <- calcOutput("LandTypeAreasAggregated", res = res, zeroValue = 10^-10, aggregate = FALSE)
  message("Relevant data read in. (1/6)")

  # align data sets by projecting soc onto weight and masking weight onto soc
  soc    <- terra::project(soc, weight)
  weight <- terra::mask(weight, soc)
  message("Aligning data sets (2/6)")

  # aggregate weight to intermediate target resolution
  # (for further processing to happen in memory)
  weight25 <- terra::aggregate(weight, fact = 30, fun = "sum", na.rm = TRUE)
  message("Land use aggregation to 0.25deg completed. (3/6)")

  # area weighted aggregation of SOC to 0.25 degree
  soc25 <- terra::aggregate(soc * weight, fact = 30, fun = "sum", na.rm = TRUE) / weight25
  names(soc25) <- names(weight25)
  message("Area weighted SOC aggregation to 0.25deg completed. (4/6)")

  # convert to magpie objects and clean coordinate values
  .clean2magpie <- function(x) {
    x <- as.magpie(x)
    getCoords(x) <- round(getCoords(x), 3)
    return(x)
  }

  # add country ISO codes
  .getCountryTemplate <- function() {
    worldCountries <- calcOutput("WorldCountries", aggregate = FALSE)
    worldRaster <- terra::rasterize(worldCountries, soc25, "ISO", touches = TRUE)
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
      getItems(tmp, dim = 1, raw = TRUE) <- paste0("-70p0.25p0.", missing)
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
  x        <- .convert2magpie(soc25, template, missing = 0)
  weight   <- .convert2magpie(weight25, template, missing = 10^-10, silent = TRUE)
  message("Conversion to magclass completed. (5/6)")

  #message("Filling of gaps completed. (6/6)")

  return(list(x = x,
              weight = weight,
              description = "Average SOC content by land type",
              unit = "tonnes/ha",
              min = 0,
              structure.spatial = "-?[0-9]*p[0-9]*\\.-?[0-9]*p[0-9]*\\.[A-Z]{3}",
              structure.data = "(cropland|grassland|other)",
              isocountries = FALSE))
}

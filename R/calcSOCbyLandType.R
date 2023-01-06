#' Calculate SOC by land type
#'
#' Estimate soil organic carbon content split by land type
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcSOCbyLandType <- function() {

  terra::terraOptions(tempdir = getConfig("tmpfolder"))

  message("Please be patient, this will take now a while.")

  # read in SOC data
  soc <- readSource("GSOCseq", subtype = "ini", convert = FALSE)

  # get soc resolution. Rounding is performed to fix a representation problem
  # of the float value
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
  weight25 <- terra::aggregate(weight, fact = 30, fun = "sum", na.rm=TRUE)
  message("Land use aggregation to 0.25deg completed. (3/6)")

  # area weighted aggregation of SOC to 0.25 degree
  soc25 <- terra::aggregate(soc * weight, fact = 30, fun = "sum", na.rm = TRUE) / weight25
  message("Area weighted SOC aggregation to 0.25deg completed. (4/6)")

  # convert to magpie objects and clean coordinate values
  x <- as.magpie(soc25)
  getCoords(x) <- round(getCoords(x), 2)
  weight <- as.magpie(weight25)
  getCoords(weight) <- round(getCoords(weight), 2)
  message("Conversion to magclass completed. (5/6)")

  # add country ISO codes
  worldCountries <- calcOutput("WorldCountries", aggregate = FALSE)
  countryMap <- terra::mask(terra::rasterize(worldCountries, soc25, "value"), soc25[[1]])
  countryCodes <- as.data.frame(countryMap, na.rm=FALSE)[terra::cellFromXY(countryMap, getCoords(x)),]
  countryCodes <- levels(countryCodes)[countryCodes]
  getItems(x, dim = "country", maindim = 1)      <- countryCodes
  getItems(weight, dim = "country", maindim = 1) <- countryCodes
  message("Country codes added. (6/6)")

  return(list(x = x,
              weight = weight,
              description = "Average SOC content by land type",
              unit = "tonnes/ha",
              isocountries = FALSE))
}

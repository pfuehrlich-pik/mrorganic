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

  message("Please be patient, this will take now a while.")

  # read in SOC data
  soc <- readSource("GSOCseq", subtype = "ini", convert = FALSE)

  # get soc resolution
  res <- round(terra::res(soc)[1], 9)

  # read in aggregated area information and setting zeroValue to 10^-10 to ensure
  # that all values are > 0 so that it can be used as weight
  weight <- calcOutput("LandTypeAreasAggregated", res = res, zeroValue = 10^-10, aggregate = FALSE)
  message("Relevant data read in.")

  out <- toolAggregateByLandType(soc, weight)

  return(list(x = out$x,
              weight = out$weight,
              description = "Average SOC content by land type",
              unit = "tonnes/ha",
              min = 0,
              structure.spatial = "-?[0-9]*p[0-9]*\\.-?[0-9]*p[0-9]*\\.[A-Z]{3}",
              structure.data = "(cropland|grassland|other)",
              isocountries = FALSE))
}

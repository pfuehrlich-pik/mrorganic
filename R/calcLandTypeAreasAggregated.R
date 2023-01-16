#' Aggregate land type areas
#'
#' Aggregate land type area information to a desired resolution
#'
#' @param res target resolution
#' @param zeroValue value for cells with no area. Useful to change to a very
#' small number if the area information should be used as weight.
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcLandTypeAreasAggregated <- function(res, zeroValue = 0) {
  terra::terraOptions(tempdir = getConfig("tmpfolder"))
  message("Please be patient, this will take now a while.")

  # read in area information
  x <- calcOutput("LandTypeAreas", aggregate = FALSE)

  # round to fix floating point issues
  fact <- round(res / terra::res(x), 2)

  # check if fact is an integer value
  if (!identical(round(fact), fact)) stop("Resolution must be a integer multiple of ", terra::res(x)[1])

  # aggregate area information to SOC resolution and add very small area to each cell
  # ensuring that all values are > 0 so that it can be used as weight
  out <- terra::aggregate(x, fact = fact, fun = "sum") +  zeroValue
  return(list(x = out,
              description = "Estimated, aggregated area for cropland, grassland and other types based on ESACCI data.",
              unit = "ha",
              class = "SpatRaster"))
}

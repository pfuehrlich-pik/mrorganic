#' Calculate land type areas
#'
#' Convert ESACCI landcover information into area information for selected
#' land types cropland, grassland and other.
#'
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcLandTypeAreas <- function() {
  terra::terraOptions(tempdir = getConfig("tmpfolder"))
  land <- readSource("ESACCI", subtype = "landcover2010", convert = FALSE)
  m <- rbind(c(10, 1), c(20, 1), c(30, 1), c(130, 2))
  message("Please be patient, this will take now a while.")
  cropGrassOther <- terra::classify(land, m, others = 3)
  out <- terra::segregate(cropGrassOther) * terra::cellSize(land, unit = "ha")
  names(out) <- c("cropland", "grassland", "other")
  return(list(x = out,
              description = "Estimated area for cropland, grassland and other types based on ESACCI data.",
              unit = "ha",
              class = "SpatRaster"))
}

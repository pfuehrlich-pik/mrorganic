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
  land <- readSource("ESACCI", subtype="landcover2010", convert=FALSE)
  m <- rbind(c(10, 1), c(20, 1), c(30, 1), c(130, 2))
  cropGrassOther <- terra::classify(land, m, others = 3)
  out <- terra::segregate(cropGrassOther)*terra::cellSize(land, unit="ha")
  return(list(x = out, class = "SpatRaster"))
}

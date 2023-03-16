#' Calculate land type areas
#'
#' Convert ESACCI landcover information into area information for selected
#' land types cropland, grassland and other.
#'
#' @param categories Categories land should be segregated into. Only available
#' option is currently "CropGrassOther".
#' @return data
#'
#' @author Jan Philipp Dietrich
#' @examples
#' \dontrun{
#' a <- calcOutput("LandTypeAreas")
#' }
#' @seealso \code{\link{calcOutput}}

calcLandTypeAreas <- function(categories = "CropGrassOther") {

  if (categories == "CropGrassOther") {
    m  <- list(map = rbind(c(10, 1), c(20, 1), c(30, 1), c(130, 2)),
               names = c("cropland", "grassland", "other"))
  } else {
    stop("Unknown categories \"", categories, "\"")
  }

  terra::terraOptions(tempdir = getConfig("tmpfolder"))
  land <- readSource("ESACCI", subtype = "landcover2010", convert = FALSE)
  message("Please be patient, this will take now a while.")
  cropGrassOther <- terra::classify(land, m$map, others = 3)
  out <- terra::segregate(cropGrassOther) * terra::cellSize(land, unit = "ha")
  names(out) <- m$names
  return(list(x = out,
              description = "Estimated area for cropland, grassland and other types based on ESACCI data.",
              unit = "ha",
              class = "SpatRaster"))
}

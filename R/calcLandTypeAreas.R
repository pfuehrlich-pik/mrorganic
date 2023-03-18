#' Calculate land type areas
#'
#' Convert ESACCI landcover information into area information for selected
#' land types cropland, grassland and other.
#'
#' @param categories Categories land should be segregated into. Only available
#' options are currently "CropGrassOther" and "CropGrassForestOthervegResidual".
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
    m  <- list(map = rbind(c(10, 1), c(11, 1), c(12, 1), c(20, 1), c(30, 1), c(40, 1), c(130, 2)),
               names = c("cropland", "grassland", "other"))
  } else if (categories == "CropGrassForestOthervegResidual") {
    m  <- list(map = rbind(c(10, 1), c(11, 1), c(12, 1), c(20, 1), c(30, 1), c(40, 1),
                           c(130, 2),
                           c(50, 3), c(60, 3), c(61, 3), c(62, 3), c(70, 3), c(71, 3), c(72, 3),
                           c(80, 3), c(81, 3), c(82, 3), c(90, 3),
                           c(100, 4), c(110, 4), c(120, 4), c(121, 4), c(122, 4), c(140, 4), c(150, 4),
                           c(151, 4), c(152, 4), c(153, 4), c(160, 4), c(170, 4), c(180, 4)),
               names = c("cropland", "grassland", "forest", "other natural", "residual"))
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

#' calcEcoregions2017Raster
#'
#' Produces a raster with ecoregion information.
#'
#' @param nrows Number of rows in the raster produced.
#' @param ncols Number of columns in the raster produced.
#' @return A raster with ecoregion information as a data.frame
#'
#' @author Pascal Führlich
calcEcoregions2017Raster <- function(nrows = 720, ncols = 1440) {
  ecoregions <- readSource("Ecoregions2017")
  ecoregionsRaster <- terra::rasterize(ecoregions, terra::rast(nrows = nrows, ncols = ncols), "OBJECTID",
                                       touches = TRUE, background = NA)
  x <- merge(terra::as.data.frame(ecoregionsRaster, xy = TRUE),
             terra::as.data.frame(ecoregions), by = "OBJECTID")

  return(list(x = x,
              description = paste0("A ", nrows, "x", ncols, " raster with data from Ecoregions 2017."),
              unit = "categorical",
              class = "data.frame",
              isocountries = FALSE))
}

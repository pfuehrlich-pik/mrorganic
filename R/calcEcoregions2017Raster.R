#' calcEcoregions2017Raster
#'
#' Produces a raster with ecoregion information as a magclass object.
#'
#' @param ecoregionsColumn Which column of the ecoregions dataset should be in the raster.
#' @param nrows Number of rows in the raster produced.
#' @param ncols Number of columns in the raster produced.
#' @return A raster with ecoregion information (ecoregionsColumn) as a magclass object
#'
#' @author Pascal Führlich
calcEcoregions2017Raster <- function(ecoregionsColumn = "ECO_BIOME_", nrows = 720, ncols = 1440) {
  stopifnot(length(ecoregionsColumn) == 1)
  ecoregions <- readSource("Ecoregions2017")
  stopifnot(ecoregionsColumn %in% names(ecoregions))
  x <- terra::rasterize(ecoregions, terra::rast(nrows = nrows, ncols = ncols), ecoregionsColumn,
                        touches = TRUE, background = NA)
  return(list(x = magclass::as.magpie(x),
              description = paste0("A ", nrows, "x", ncols, " raster with ",
                                   ecoregionsColumn, " data from Ecoregions 2017."),
              unit = "categorical",
              isocountries = FALSE))
}

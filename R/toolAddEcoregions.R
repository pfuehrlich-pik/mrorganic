#' toolAddEcoregions
#'
#' Enriches rasterdata with ecoregion information.
#'
#' @param x A SpatRaster
#' @param ecoregionsColumns Which columns of the ecoregions dataset should be added.
#' @return x with additional ecoregion information
#'
#' @author Pascal Führlich
#' @export
toolAddEcoregions <- function(x, ecoregionsColumns = c("ECO_BIOME_", "BIOME_NAME", "REALM")) {
  if (!inherits(x, "SpatRaster")) {
    stop("x must be a SpatRaster")
  }
  ecoregions <- readSource("Ecoregions2017")
  if (!all(ecoregionsColumns %in% names(ecoregions))) {
    stop("The following columns do not exist in ecoregions: ",
         paste(ecoregionsColumns[!(ecoregionsColumns %in% names(ecoregions))], collapse = ", "),
         "\navailable columns are: ", paste(names(ecoregions), collapse = ", "))
  }
  biomes <- terra::rasterize(ecoregions, x, ecoregionsColumns, touches = TRUE)
  return(c(x, biomes))
}

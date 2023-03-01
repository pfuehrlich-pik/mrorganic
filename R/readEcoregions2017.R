readEcoregions2017 <- function() {
  x <- terra::vect("Ecoregions2017.shp")
  return(list(x = x, class = "SpatVector", cache = FALSE))
}

readKoeppenGeiger <- function() {
  return(list(x = terra::rast("Beck_KG_V1_present_0p5.tif"),
              class = "SpatRaster"))
}

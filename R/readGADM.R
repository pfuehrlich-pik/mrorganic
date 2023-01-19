readGADM <- function() {
  x <- geodata::gadm(madrat::getISOlist(), 0, ".", version = "4.1", resolution = 2)
  return(list(x = x, class = "SpatVector", cache = FALSE))
}

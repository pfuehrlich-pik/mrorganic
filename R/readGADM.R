readGADM <- function() {
  countryCodes <- setdiff(madrat::getISOlist(), c("HKG", "MAC")) # Hongkong and Macao are missing
  x <- geodata::gadm(countryCodes, level = 0, path = ".", version = "4.1", resolution = 2)
  return(list(x = x, class = "SpatVector"))
}
